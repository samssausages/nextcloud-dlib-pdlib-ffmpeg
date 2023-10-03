# nextcloud-dlib-pdlib-ffmpeg
## Dockerfile that includes dependencies for AI Image Recognition
### should just be able to build this and go!




## Apache with HTTPS SSL Certificate
### dockerfile_ssl is a dockerfile that lets you install/use your own certificate with Apache (No reverse Proxy)

1. Make sure the dockerfile_ssl and the setssl.sh are in the same folder
2. edit dockerfile_ssl to add your domain name and email address.  Look for this line:
`RUN /usr/local/bin/setssl.sh subdomain.domain.com admin@domain.com`
4. Navigate to folder and run `docker build -t dockerfile_ssl .`
5. Update your docker-compose file to use the image you created. (Whaever you named it)
6. Add a volume mapping to the certificate files in your docker compose files.  I'm using ACME in pfsense to generate my certificates, so that's the naming convention I'm showing in this example.  But other methods to generate them will work as well.  Should look like this, modify with location and name to your certificate file:
```
    volumes:
      # For Certificates
      - /mnt/certs/subdomain.domain.com.all.pem:/etc/ssl/nextcloud/cert.pem:ro
      - /mnt/certs/subdomain.domain.com.key:/etc/ssl/nextcloud/key.pem:ro
```
5. Profit
