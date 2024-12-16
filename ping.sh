#!/bin/bash


read -p "Введите адрес для пинга: " address

error_count=0

while true; do
  result=$(ping -c 1 "$address" 2>/dev/null)
  
  if [[ $? -ne 0 ]]; then
    echo "Не удалось выполнить пинг до $address"
    ((error_count++))
  else
    time=$(echo "$result" | grep -oP 'time=\K[\d\.]+')
    if (( $(echo "$time > 100" | bc -l) )); then
      echo "Время пинга превышает 100 мс: $time мс"
      ((error_count++))
    else
      echo "Ответ от $address: время=${time} мс"
      error_count=0
    fi
  fi
  
  if [[ $error_count -ge 3 ]]; then
    echo "Проблема с подключением: 3 последовательных ошибки пинга."
    break
  fi
  
  sleep 1
done
