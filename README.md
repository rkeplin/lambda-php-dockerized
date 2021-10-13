# Introduction
This is a boilerplate for running a PHP lambda function in AWS.  The same pattern may be used for other languages that aren't supported by AWS out of the box.

# Prerequisite
* Install docker
  ```
  docker -v
  Docker version 19.03.12, build 48a6621
  ```
* Install serverless
  ```
  sls -v
  Framework Core: 2.57.0
  Plugin: 5.4.4
  SDK: 4.3.0
  Components: 3.16.0
  ```
* Download REI runtime
  ```
  mkdir -p ~/.aws-lambda-rie && curl -Lo ~/.aws-lambda-rie/aws-lambda-rie \
  https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/latest/download/aws-lambda-rie \
  && chmod +x ~/.aws-lambda-rie/aws-lambda-rie
  ```

# Build the image
```
docker image build -t phplambda .
```

# Testing Locally

### Spin up the container
```
docker run -v ~/.aws-lambda-rie:/aws-lambda --entrypoint /aws-lambda/aws-lambda-rie  -p 9000:8080 phplambda:latest /var/runtime/bootstrap index.hello
```

### Test the local lambda
```
curl "http://127.0.0.1:9000/2015-03-31/functions/function/invocations" -d '{"name":"Test"}'
```

# Testing on AWS

### Deploy the lambda
```
sls deploy
```

### Test the lambda
```
sls invoke -f hello -d '{"name":"Test"}'
```
