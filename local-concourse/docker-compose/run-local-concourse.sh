echo "check before run: docker-compose.yml> services.credhub.environment UAA_URL: http://192.168.50.1:8080/uaa"
docker-compose up -d
sleep 10
open http://test:test@localhost:8082
