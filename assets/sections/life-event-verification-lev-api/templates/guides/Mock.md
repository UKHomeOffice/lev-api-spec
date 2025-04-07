# Mock API  

It is possible to run and test against a mock version of the API as follows:

## Starting the mock

```bash
docker run --name 'lev-api-mock' -p 80:8080 --env 'MOCK=true' quay.io/ukhomeofficedigital/lev-api:latest
```

The API can then be accessed on [localhost] over plain HTTP, rather than HTTPS.

**Note:** To run a specific version of the API simply replace `latest` in the command above with the version you require. We try to follow [Semantic versioning] so valid examples include:

* `0.0.1`
* `0.0`
* `0`

**Note:** You won't need to supply a OAuth2 bearer token nor a client certificate to the mock but you will need to supply the following dummy headers:

* `x-original-client: YOUR_CLIENT_HERE`
* `X-Auth-Username: SOME_USER`

(See [Authenticating against the mock] for more details.)

## Obtain record for mock request

In a terminal:

* Start a shell in a running docker container:

```bash
docker exec -it  lev-api-mock
```

* List the files within the mock directory:

```bash
ls mock/

birth_registration_v0.json        lev_audit.json
birth_registration_v1.json        marriage_registration_v1.json
death_registration_v1.json        partnership_registration_v1.json
```
Note: The files will be the latest versions of the [API Mock Data]. You can also add your own json files to test your 
own requirements.

* Search of list of available id's within the relevant file:

```bash
grep "id" mock/{file}

"id": 123456789,
"id": 999999902,
"id": 999999903,
"id": 999999910
```

* Exit the container:

```bash
exit
```

## Getting data from the API
Once the API is running locally, and a valid test record ID has been obtained, a request to the mock can be sent:

```bash
curl -s -H 'x-auth-username: test' -H 'x-original-client: test' 'http://localhost/v1/registration/{dataset}/{ID}'
```

[localhost]: http://localhost/
[Semantic versioning]: https://semver.org/
[Authenticating against the mock]: ./Authentication#authenticating-against-the-mock
[API Mock Data]: https://github.com/UKHomeOffice/lev-api/tree/master/mock
