Authentication
==============

To use the API you will need to provide two forms of authentication:

* [A client TLS certificate]
* [An OAuth2 bearer token]


Client TLS certificate
----------------------

A self-signed certificate that you must have previously sent to us and that we have agreed to trust. In order for us to trust your certificate it must meet the following standards:

1. It must expire in no more than two years
2. It must be at least 2048 bit in length
3. It must use the SHA256 hash algorithm


### Generating a key-pair

The private key and public certificate can be generated using the `openssl` command-line tool. e.g.

```bash
openssl genrsa -out private.key 4096
openssl req -new -x509 -sha256 -key private.key -subj "/CN=YOUR_CLIENT" -days 730 -out public.crt
```

---

**Note:** You must keep your private key safe. It should be deployed as a secret with your client and should not be shared with anyone. (Only the public certificate should be sent to us.)

Should your private key be compromised you must let us know, generate a new one, and send us the, new, public certificate as soon as possible.

---


OAuth2 bearer token
-------------------

An [OAuth2] token supplied in an HTTP header as follows:

```
Authorization: Bearer YOUR_TOKEN
```

Where `YOUR_TOKEN` must be obtained, via [OpenID Connect], from our authentication server, https://sso.digital.homeoffice.gov.uk/auth/realms/lev/.well-known/openid-configuration . The exact authentication 'flow' you use will depend on what you have agreed with us.


Authenticating against the mock
-------------------------------

If you wish to test your client against the [mock API] then you might also want to send the following headers:

* `X-Auth-Aud`: The name of you client.
* `X-Auth-Username`: The user your client is currently serving.

Both of these can simply be set to dummy values to ease testing. The client certificate and bearer token are not required.

[A client TLS certificate]: #client-tls-certificate
[An OAuth2 bearer token]: #oauth2-bearer-token
[OAuth2]: https://oauth.net/2/
[OpenID Connect]: https://www.keycloak.org/docs/3.3/server_admin/topics/sso-protocols/oidc.html
[mock API]: ./Mock
