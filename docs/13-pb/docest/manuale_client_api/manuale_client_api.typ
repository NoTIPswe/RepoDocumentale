#import "../../00-templates/base_document.typ" as base-document

#let metadata = yaml("manuale_client_api.meta.yaml")

#base-document.apply-base-document(
  title: metadata.title,
  abstract: "Documento contenente il manuale utente della piattaforma, con attenzione focalizzata alle funzionalità offerte al Tenant User e Admin.",
  changelog: metadata.changelog,
  scope: base-document.EXTERNAL_SCOPE,
)[
  = Introduzione
  Il presente documento contiene il manuale riservato agli utenti che vogliono utilizzare il sistema dall'esterno. Con
  utenti esterni si intendono Client che implementano la propria interfaccia utente per interagire con gli endpoint API
  REST messi a disposizione dal Sistema.

  = Prerequisiti
  - Credenziali: ottenibili dal Tenant Admin al momento della registrazione del Client nel Tenant.
  - Bearer Token: ottenibile facendo una richiesta HTTP Post all'endpoint di token di Keycloak:



  ```bash
  POST http://localhost/auth/realms/notip/protocol/openid-connect/token
  Content-Type: application/x-www-form-urlencoded
  grant_type=client_credentials &
  client_id={client_id} &
  client_secret={client_secret}
  ```
  dove `{client_id}` e `{client_secret}` sono rispettivamente l'ID e il segreto del Client registrato nel Tenant.

  - Esempio di risposta:```JSON {
    "access_token":
    "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJGMVVNeWVPYldJRmdFR0o5a3A2QUFFNkRnbkxIWVZWdmtJTldtVDUzREtrIn0.eyJleHAiOjE3NzU4NzQ4NjUsImlhdCI6MTc3NTg3Mzk2NSwianRpIjoidHJydGNjOmVmMzcyMTI1LWE5ZjYtYWY4My1kY2Y1LWFlYzY2MDA2MjMzZSIsImlzcyI6Imh0dHA6Ly9sb2NhbGhvc3QvYXV0aC9yZWFsbXMvbm90aXAiLCJhdWQiOlsibm90aXAtbWdtdC1iYWNrZW5kIiwiYWNjb3VudCJdLCJzdWIiOiI0ZTI0ZmUzMi1hYWRmLTQ0YzItOWUwMS1jYjk3ZDk4NjZjN2UiLCJ0eXAiOiJCZWFyZXIiLCJhenAiOiJwcm92YTEiLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsiZGVmYXVsdC1yb2xlcy1ub3RpcCIsInRlbmFudF9hZG1pbiIsIm9mZmxpbmVfYWNjZXNzIiwidW1hX2F1dGhvcml6YXRpb24iXX0sInJlc291cmNlX2FjY2VzcyI6eyJhY2NvdW50Ijp7InJvbGVzIjpbIm1hbmFnZS1hY2NvdW50IiwibWFuYWdlLWFjY291bnQtbGlua3MiLCJ2aWV3LXByb2ZpbGUiXX19LCJzY29wZSI6Im5vdGlwLWNsYWltcyBub3RpcC1yb2xlcyIsInRlbmFudF9pZCI6IjJmNjA0OWI1LWViMTEtNGIwNi04ZDA4LTNhY2M4ZTUzOWY4YiIsInJvbGUiOiJ0ZW5hbnRfYWRtaW4iLCJ1c2VybmFtZSI6InNlcnZpY2UtYWNjb3VudC1wcm92YTEifQ.RWWZSiGPtmqn6YlnOCPrHHetYadMuHWiddMbV6Qs6jgOSIyS3ecg3_ZbSpOdfbz6rxszot452rYF-Z5V6IY6rlJUjlW8jfO7hkTryh7qxi5lUMPC1X0Lk_wOWN1XiAQQZlQWHnQGlHGtzitZm_EohTaAdPXwjZRod3NFWPsM8CVC9TtWZLwx0eaGr3GMk3lKFYG691usJrusxZ0vqyKYrH95fbs3RzvZCAf-djV41DUXjCv_xXFnreT1Hl-nRWeKpJRTI3VVIKmKFIG9PZYlVaeLVpjZK9zceZIUMYdexLsZMiFAsPeYaJUwjcmgTHEv91lG2L5XIGXPpy3AHndDw",
    "expires_in": 900,
    "refresh_expires_in": 0,
    "token_type": "Bearer",
    "not-before-policy": 0,
    "scope": "notip-claims notip-roles"
    }
    ```

]
