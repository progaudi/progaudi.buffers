FROM microsoft/dotnet:2.1-sdk as builder

WORKDIR /app
ADD . /app

RUN IsDocker=defined dotnet build -c Release progaudi.buffers.sln

RUN cat ./scripts/.travis.sdk2.txt | xargs -I {} dotnet test -c Release -f {} --no-build ./tests/progaudi.buffers.tests/progaudi.buffers.tests.csproj -- -parallel assemblies

FROM microsoft/dotnet:1.1-sdk

WORKDIR /app

COPY --from=builder /app .

RUN dotnet restore progaudi.buffers.sln

RUN cat ./scripts/.travis.sdk1.txt | xargs -I {} dotnet test -c Release -f {} --no-build ./tests/progaudi.buffers.tests/progaudi.buffers.tests.csproj -- -parallel assemblies
