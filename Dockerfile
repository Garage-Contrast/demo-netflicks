FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS publish
WORKDIR /src
COPY ./DotNetFlicks.Accessors ./DotNetFlicks.Accessors
COPY ./DotNetFlicks.Common ./DotNetFlicks.Common 
COPY ./DotNetFlicks.Engines ./DotNetFlicks.Engines
COPY ./DotNetFlicks.Managers ./DotNetFlicks.Managers
COPY ./DotNetFlicks.ViewModels ./DotNetFlicks.ViewModels
COPY ./DotNetFlicks.Web ./DotNetFlicks.Web 
COPY ./DotNetFlicks.sln ./DotNetFlicks.sln
RUN dotnet publish "DotNetFlicks.Web/Web.csproj" /p:Platform=x64 -c Release -o /app

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS final
RUN uname -a
RUN apt-get update && apt-get --assume-yes install libnss3-tools
WORKDIR /app
EXPOSE 8080
ENV ASPNETCORE_URLS=http://*:8080
COPY --from=publish /app .
RUN chmod -R 775 /app

ENTRYPOINT ["dotnet", "DotNetFlicks.Web.dll"]