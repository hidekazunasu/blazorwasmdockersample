FROM nginx AS base
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["blazorwasmsample.csproj", "dockersample/"]
RUN dotnet restore "dockersample/blazorwasmsample.csproj"

COPY . ./dockersample/
WORKDIR "/src/dockersample"
RUN dotnet build "blazorwasmsample.csproj" -c Release -o /app/build

FROM build AS publish 
RUN dotnet publish "blazorwasmsample.csproj" -c Release -o /app/publish /p:UserAppHost=false 

FROM  base AS final
WORKDIR /usr/share/nginx/html

COPY --from=publish /app/publish/wwwroot .
COPY nginx.conf /etc/nginx/nginx.conf