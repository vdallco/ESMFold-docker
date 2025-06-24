# ESMFold Dockerfile

## Pull
```
docker.io/cody8295/esmfold-arbius:latest
```

## Build
```
docker build -t esmfold-arbius .
```

## Run
```
docker run --gpus all -p 8080:8080 esmfold-arbius
```

## Test
```
curl -X POST "http://localhost:8080/predict" -H "Content-Type: application/json" -d '{"sequence":"MKTVRQERLKSIVRILERSKEPVSGAQLAEELSVSRQVIVQDIAYLRSLGYNIVATPRGYVLAGG"}' -o result.pdb
```
