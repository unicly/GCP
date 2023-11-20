import csv
import random
import constants as const

"""
This script generates test data and saves it to a CSV file.
"""

# Sample data
products = ["Laptop", "Smartphone", "Headphones", "Keyboard", "Mouse"]
status = ["Purchased", "Cancelled", "Returned"]
columns = ["ClientID", "Product", "Quantity", "Status"]

with open(f"{const.FILE_NAME}", "w", newline="") as file:
    writer = csv.writer(file)
    writer.writerow(columns)

    for i in range(100):  # Generate 100 records
        writer.writerow([f"Client_{i}", 
                         random.choice(products), 
                         random.randint(1, 5), 
                         random.choice(status)])
