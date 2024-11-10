import psycopg2


def connect_to_db(location):
    try:
        if location == 'asia':
            conn = psycopg2.connect(
                dbname="asia_region",
                user="postgres",
                password="1234",
                host="localhost"
            )
        elif location == 'eu':
            conn = psycopg2.connect(
                dbname="eu_region",
                user="postgres",
                password="1234",
                host="localhost"
            )
        elif location == 'us':
            conn = psycopg2.connect(
                dbname="us_region",
                user="postgres",
                password="1234",
                host="localhost"
            )
        else:
            raise ValueError("Invalid location")
        print(f"Connected to {location} database.")
        return conn
    except Exception as e:
        print(f"Error connecting to database: {e}")
        return None


def run_query(conn, query):
    try:
        cursor = conn.cursor()
        cursor.execute(query)

        # Fetch results if it's a SELECT query
        if query.strip().lower().startswith("select"):
            rows = cursor.fetchall()
            for row in rows:
                print(row)
        else:
            conn.commit()
            print("Query executed successfully.")

        cursor.close()

    except psycopg2.Error as e:
        print(f"Database error: {e}")
        conn.rollback()  # Rollback transaction if error occurs
    except Exception as e:
        print(f"Error executing query: {e}")
        conn.rollback()  # Rollback transaction if error occurs


def main():
    connections = {}  # Dictionary to hold active connections
    active_location = None

    while True:
        print("\nActive Connections:", list(connections.keys()))
        if active_location:
            print(f"Currently connected to: {active_location}")

        command = input(
            "Enter location (asia, eu, us) to connect, 'switch' to change active connection, 'exit' to quit: ").strip().lower()

        if command == 'exit':
            print("Closing all connections and exiting the program.")
            for conn in connections.values():
                conn.close()
            break

        elif command == 'switch':
            if connections:
                new_location = input("Enter location to switch to: ").strip().lower()
                if new_location in connections:
                    active_location = new_location
                    print(f"Switched to {active_location} database.")
                else:
                    print("No active connection to this location. Please connect first.")
            else:
                print("No active connections available to switch.")

        elif command in ['asia', 'eu', 'us']:
            if command not in connections:
                conn = connect_to_db(command)
                if conn:
                    connections[command] = conn
                    active_location = command
            else:
                print(f"Already connected to {command}. Switching to it.")
                active_location = command

            if active_location:
                while True:
                    query = input(
                        "Enter your SQL query, 'back' to choose another location, or 'exit' to quit: ").strip()
                    if query.lower() == 'back':
                        break
                    elif query.lower() == 'exit':
                        print("Exiting the program.")
                        for conn in connections.values():
                            conn.close()
                        return
                    else:
                        run_query(connections[active_location], query)

        else:
            print("Invalid input. Please enter a valid location or command.")


if __name__ == "__main__":
    main()
