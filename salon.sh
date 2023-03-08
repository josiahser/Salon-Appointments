#! /bin/bash
#for queries
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

MAIN_MENU(){
  #Phrase for returning to main menu
  if [[ $1 ]]
    then
    echo -e "\n$1"
  fi
#welcoming
echo -e "\n~~~ Welcome to the salon! ~~~\n"
echo -e "What can I help you with?\n"
#Collect services
SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id;")
#list services
echo "$SERVICES" | while read SERVICE_ID BAR SERVICE
do
  echo "$SERVICE_ID) $SERVICE"
done
#read input and go to chosen 
read SERVICE_ID_SELECTED
case $SERVICE_ID_SELECTED in
    1) HAIRCUT ;;
    2) HAIRCUT ;;
    3) HAIRCUT ;;
    *) MAIN_MENU "Please choose a valid service." ;;
  esac
}

HAIRCUT(){
echo -e "\n What's your phone number?"
read CUSTOMER_PHONE
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
if [[ -z $CUSTOMER_NAME ]]
  then
  echo -e "\nWe don't have you in our system. What's your name?"
  read CUSTOMER_NAME
  INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
fi
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

echo -e "\nWhat time would you like your appointment, $CUSTOMER_NAME?"
read SERVICE_TIME
SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_ID_SELECTED'")
INSERT_APT_RESULTS=$($PSQL "INSERT INTO appointments(time, customer_id, service_id) VALUES ('$SERVICE_TIME','$CUSTOMER_ID', $SERVICE_ID_SELECTED)")

echo "I have put you down for a $(echo $SERVICE | sed -r 's/^ *| *$//g') at $(echo $SERVICE_TIME | sed -r 's/^ *| *$//g'), $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')."
}

MAIN_MENU
