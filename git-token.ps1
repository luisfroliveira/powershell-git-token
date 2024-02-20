$adtoken = Get-AzAccessToken

$Headers = @{
    "Content-Type" = "application/json"
    Authorization = "Bearer $($adtoken.Token)"
}
      
$Url = "https://vssps.dev.azure.com/{organization}/_apis/tokens/pats?api-version=7.2-preview.1"
$tokens = Invoke-RestMethod -Uri $Url -Headers $Headers -Method GET

      foreach($token in $tokens.patTokens){
        $body = @{
          authorizationId = $token.authorizationId
          validTo = (Get-Date ((Get-Date).AddDays(180)) -Format "MM/dd/yyyy HH:mm:ss")
        }

        $pat = Invoke-RestMethod -Uri $Url -Headers $Headers -Method PUT -Body (ConvertTo-Json $body)

        Write-Output "Token renovado: $($pat.patToken.displayName)"
      }
