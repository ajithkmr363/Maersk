FROM microsoft/dotnet:2.2-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/dotnet:2.2-sdk AS build
WORKDIR /src
COPY MaerskAPI/MaerskAPI.csproj MaerskAPI/
COPY MaerskAPI.BusinessLayer/MaerskAPI.BusinessLayer.csproj MaerskAPI.BusinessLayer/
COPY MaerskAPI.DataLayer/MaerskAPI.DataLayer.csproj MaerskAPI.DataLayer/
COPY Nuget.config Nuget/
RUN dotnet restore "MaerskAPI/MaerskAPI.csproj" --configfile Nuget/Nuget.config --verbosity Detailed
COPY . .
WORKDIR /src/MaerskAPI
RUN dotnet build MaerskAPI.csproj -c Release -o /app

FROM build AS publish
RUN dotnet publish MaerskAPI.csproj -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "MaerskAPI.dll"]
