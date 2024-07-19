#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ AHSOKA'S SALON ~~~~~\n"

# displays the menu options
SERVICES_MENU() {
  
  # displays initial message or parameter error message 
  if [[ $1 ]]
  then
    echo -e "\n$1"
  else
    echo -e "Welcome to Ahsoka's Salon, how can I help you?\n"
  fi

  # get services list
  SERVICES_LIST_RESULT=$($PSQL "SELECT service_id, name FROM services")

  # display services
  echo "$SERVICES_LIST_RESULT" | while read SERVICE_ID BAR SERVICE_NAME 
  do 
    echo "$SERVICE_ID) $SERVICE_NAME"
  done

  read SERVICE_ID_SELECTED

  # we validate the input 
  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  then
    #return to services menu
    SERVICES_MENU "\nI could not find that service, try again."
  else
    APPOINTMENT_SCHEDULER
  fi
}

APPOINTMENT_SCHEDULER() {
  
  # we get the service name
  SERVICE_NAME_RESULT=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
  
  if [[ -z $SERVICE_NAME_RESULT ]]
  then
    # return to menu with the message error
    SERVICES_MENU "I could not find that service, try again."
  else

    echo -e "\nEnter your phone number:"
    read CUSTOMER_PHONE

    # we get the customer's name using his phone 
    CUSTOMER_NAME_RESULT=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

    # if it isn't in the DB we ask for the user information and the appointment info
    if [[ -z $CUSTOMER_NAME_RESULT ]]
    then

      echo -e "\nEnter your name:"
      read CUSTOMER_NAME
      
      # insert into customer table
      CUSTOMER_INSERT_RESUTL=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")

      echo -e "\nEnter appointment time, $CUSTOMER_NAME:"
      read SERVICE_TIME

      CUSTOMER_ID_RESULT=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
      
      #insert into appointments table
      APPOINTMENT_INSERT_RESUTL=$($PSQL "INSERT INTO appointments(customer_id,service_id, time) VALUES($CUSTOMER_ID_RESULT, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
      
      echo -e "\nI have put you down for a $(echo $SERVICE_NAME_RESULT | sed -r 's/^ *| *$//g') at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g').\n"

    else # if the user is in the DB we just ask for the appontment info
    
      #insert into db
      echo -e "\nWhat time would you like your appointment, $CUSTOMER_NAME_RESULT?"
      read APPOINTMENT_TIME

      CUSTOMER_ID_RESULT=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

      APPOINTMENT_INSERT_RESULT=$($PSQL "INSERT INTO appointments(customer_id,service_id, time) VALUES($CUSTOMER_ID_RESULT, $SERVICE_ID_SELECTED, '$APPOINTMENT_TIME')")

      echo -e "\nI have put you down for a $(echo $SERVICE_NAME_RESULT | sed -r 's/^ *| *$//g') at $APPOINTMENT_TIME, $(echo $CUSTOMER_NAME_RESULT | sed -r 's/^ *| *$//g').\n"
          
    fi

  fi


}

# invoke the function that displays the service options
SERVICES_MENU


