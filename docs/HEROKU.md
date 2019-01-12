1. To delete a user: 
    ```
    $ heroku run rails console
    $ User.find(1).destroy
    ```
2.  Forward Google Domain
    ```
    1. https://support.google.com/domains/answer/4522141?hl=en
    2. https://domains.google.com/m/registrar/speedoss.com/dns?hl=en
    3. Tutorial: https://collectiveidea.com/blog/archives/2016/01/12/lets-encrypt-with-a-rails-app-on-heroku
    ```
3. For Google API Service Account: 
    ```
    https://console.cloud.google.com/apis/api/gmail.googleapis.com/overview?project=speed-1547169717282&authuser=5&organizationId=379301004919
    
    For granting IAM roles:
    https://console.cloud.google.com/projectselector/iam-admin/serviceaccounts?_ga=2.96102367.-2123620946.1547141368&supportedpurview=project&angularJsUrl=%2Fprojectselector%2Fiam-admin%2Fserviceaccounts%3F_ga%3D2.96102367.-2123620946.1547141368%26supportedpurview%3Dproject&authuser=5
    ```