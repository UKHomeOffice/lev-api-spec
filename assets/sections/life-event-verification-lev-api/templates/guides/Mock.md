Mock API
========

It is possible to run a mock version of the API as follows:

```bash
docker run -p 80:8080 --env 'MOCK=true' quay.io/ukhomeofficedigital/lev-api:latest
```

The API can then be accessed on [localhost] over plain HTTP, rather than HTTPS.

**Note:** To run a specific version of the API simply replace `latest` in the command above with the version you require. We try to follow [Semantic versioning] so valid examples include:

* `0.0.1`
* `0.0`
* `0`

**Note:** You won't need to supply a OAuth2 bearer token not a client certificate to the mock but you will need to supply the following dummy headers:

* `X-Auth-Aud: YOUR_CLIENT_HERE`
* `X-Auth-Username: SOME_USER`

(See [Authenticating against the mock] for more details.)

[localhost]: http://localhost/
[Semantic versioning]: https://semver.org/
[Authenticating against the mock]: ./Authentication#authenticating-against-the-mock
