while true; do
  curl -X POST "http://weather-console:8080/api/readings" \
       -H "Content-Type: application/json" \
       -d '{
         "temperature": '"$((RANDOM % 10 + 20))"'.'"$((RANDOM % 10))"',
         "humidity": '"$((RANDOM % 50 + 30))"',
         "pressure": '"$((RANDOM % 20 + 1000))"',
         "gasResistance": '"$((RANDOM % 50000 + 50000))"'
       }'
  echo "Sent reading $i"
  sleep 1  # Wait 1 second between requests
done

