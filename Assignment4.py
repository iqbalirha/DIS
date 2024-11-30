from pymongo import MongoClient # type: ignore
import psycopg2
from datetime import datetime

class DatabaseOperations:
    def __init__(self):
        # MongoDB connection
        self.mongo_client = MongoClient('mongodb://localhost:27017/')
        self.mongo_db = self.mongo_client['store']  # Database name
        self.mongo_collection = self.mongo_db['CustOrderInfo']  # Collection name

        # PostgreSQL connection
        self.pg_conn = psycopg2.connect(
            database="asia_region",
            user="postgres",
            password="1234",
            host="localhost",
            port="5432"
        )
        self.pg_cursor = self.pg_conn.cursor()

    def print_all_data(self):
        # Print MongoDB data
        print("\nMongoDB Records:")
        for record in self.mongo_collection.find():
            print(record)

        # Print PostgreSQL data
        print("\nPostgreSQL Records:")
        self.pg_cursor.execute("SELECT * FROM customers JOIN orders ON customers.customer_id = orders.customer_id")
        for record in self.pg_cursor.fetchall():
            print(record)

    def join_databases(self):
        # Get data from both databases and join based on customer email
        mongo_data = list(self.mongo_collection.find())

        self.pg_cursor.execute("""
            SELECT c.email, c.name, o.order_id, o.total_amount 
            FROM customers c 
            JOIN orders o ON c.customer_id = o.customer_id
        """)
        pg_data = self.pg_cursor.fetchall()

        # Create a dictionary for easier joining
        mongo_dict = {record['email']: record for record in mongo_data}

        print("\nJoined Data:")
        for record in pg_data:
            if record[0] in mongo_dict:  # if email matches
                print(f"PostgreSQL: {record}")
                print(f"MongoDB: {mongo_dict[record[0]]}\n")

    def insert_data(self, data):
        # Insert into MongoDB
        mongo_result = self.mongo_collection.insert_one({
            "customer_id": data['customer_id'],
            "name": data['name'],
            "email": data['email'],
            "address": data['address'],
            "purchases": data['purchases']
        })

        # Insert into PostgreSQL
        self.pg_cursor.execute("""
            INSERT INTO customers (customer_id, name, email, address)
            VALUES (%s, %s, %s, %s)
        """, (data['customer_id'], data['name'], data['email'], data['address']))

        for purchase in data['purchases']:
            self.pg_cursor.execute("""
                INSERT INTO orders (order_id, customer_id, total_amount, status)
                VALUES (%s, %s, %s, %s)
            """, (purchase['order_id'], data['customer_id'], 
                  purchase['total_amount'], purchase['status']))

        self.pg_conn.commit()

    def delete_data(self, customer_id):
        # Delete from MongoDB
        self.mongo_collection.delete_one({"customer_id": customer_id})

        # Delete from PostgreSQL (cascade delete will handle orders)
        self.pg_cursor.execute("DELETE FROM customers WHERE customer_id = %s", (customer_id,))
        self.pg_conn.commit()

    def modify_data(self, customer_id, new_data):
        # Update MongoDB
        self.mongo_collection.update_one(
            {"customer_id": customer_id},
            {"$set": new_data}
        )

        # Update PostgreSQL
        if 'name' in new_data:
            self.pg_cursor.execute("""
                UPDATE customers 
                SET name = %s 
                WHERE customer_id = %s
            """, (new_data['name'], customer_id))

        if 'purchases' in new_data:
            for purchase in new_data['purchases']:
                self.pg_cursor.execute("""
                    UPDATE orders 
                    SET total_amount = %s, status = %s 
                    WHERE order_id = %s
                """, (purchase['total_amount'], purchase['status'], purchase['order_id']))

        self.pg_conn.commit()

    def close_connections(self):
        self.pg_cursor.close()
        self.pg_conn.close()
        self.mongo_client.close()

# Example usage
if __name__ == "__main__":
    db_ops = DatabaseOperations()

    # Sample data for insertion
    new_data = {
        "customer_id": "CUST003",
        "name": "John Doe",
        "email": "john@email.com",
        "address": "123 Pine St",
        "purchases": [
            {
                "order_id": "ORD004",
                "order_date": datetime.now(),
                "total_amount": 199.99,
                "status": "PENDING"
            }
        ]
    }

    # Perform operations
    db_ops.print_all_data()
    db_ops.join_databases()
    db_ops.insert_data(new_data)
    
    # Modify data
    modified_data = {
        "name": "John Smith",
        "purchases": [{"order_id": "ORD004", "total_amount": 299.99, "status": "SHIPPED"}]
    }
    db_ops.modify_data("CUST003", modified_data)
    
    # Delete data
    db_ops.delete_data("CUST003")
    
    db_ops.close_connections()
