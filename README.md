# nextcloud-dlib-pdlib-ffmpeg
## Dockerfile that includes dependencies for AI Image Recognition
Just `docker build -t dockerfile .` and go!




## Apache with HTTPS SSL Certificate
dockerfile_ssl is a dockerfile that lets you install/use your own certificate with Apache (No reverse Proxy)

1. Make sure dockerfile_ssl and the setssl.sh are in the same folder

2. edit dockerfile_ssl to add your domain name and email address.  Look for this line:

`RUN /usr/local/bin/setssl.sh subdomain.domain.com admin@domain.com`

3. Navigate to folder and run 

`docker build -t dockerfile_ssl .`

4. Update your docker-compose file to use the image you created. (Whatever you named it)

5. Edit docker-compose file with volume mapping to ssl certificate files.
I'm using ACME in pfsense to generate my certificates, so that's the naming convention I'm showing in this example.  But other Letsencrypt methods will work as well.  Should look like this, modify with location and name to your certificate file.  Keep the docker destination/name as is, only edit the part on the left:

```
    volumes:
      # For Certificates
      - /mnt/certs/subdomain.domain.com.all.pem:/etc/ssl/nextcloud/cert.pem:ro
      - /mnt/certs/subdomain.domain.com.key:/etc/ssl/nextcloud/key.pem:ro
```

6. Profit
