import base64

from flask import Flask, jsonify, send_from_directory, request, url_for
import psycopg2
import os

app = Flask(__name__)

app = Flask(__name__, static_url_path='/img', static_folder='../images')
# Database connection setup
def get_db_connection():
    conn = psycopg2.connect(
        database="MA_ProductShow",
        user="postgres",
        password="123",
        host="127.0.0.1",
        port="5432"
    )
    return conn

@app.route('/products', methods=['GET'])
def get_products():
    conn = get_db_connection()
    cur = conn.cursor()

    cur.execute("SELECT id, product_name, category_id, qty, price, description, image FROM prod.product")

    products = cur.fetchall()

    # Check if any products were found
    if cur.rowcount > 0:
        # Convert each row to a dictionary
        products_list = [
            {
                cur.description[i][0]: value if cur.description[i][0] != 'image' else
                url_for('static', filename=value, _external=True)
                for i, value in enumerate(row)
            }
            for row in products
        ]

        # Successful response
        response = {
            'cd': "000",
            'sms': "Product retrieval success!",
            'products_list': products_list
        }
    else:
        # No products found response
        response = {
            'cd': "888",
            'sms': "No products found!",
            'products_list': []
        }

    # Close cursor and connection
    cur.close()
    conn.close()

    # Return response as JSON
    return jsonify(response)

@app.route('/products/<int:id>', methods=['GET'])
def getbyID(id):
    conn = get_db_connection()
    cur = conn.cursor()

    cur.execute("SELECT id, product_name, category_id, qty, price, description, image FROM prod.product where id = %s", (id,))

    products = cur.fetchall()

    # Check if any products were found
    if cur.rowcount > 0:
        # Convert each row to a dictionary
        products_list = [
            {
                cur.description[i][0]: value if cur.description[i][0] != 'image' else
                url_for('static', filename=value, _external=True)
                for i, value in enumerate(row)

            }
            for row in products
        ]

        # Successful response
        response = {
            'cd': "000",
            'sms': "Product retrieval success!",
            'products_list': products_list
        }
    else:
        # No products found response
        response = {
            'cd': "888",
            'sms': "No products found!",
            'products_list': []
        }

    # Close cursor and connection
    cur.close()
    conn.close()

    # Return response as JSON
    return jsonify(response)


if __name__ == '__main__':
    app.run(debug=True, port=5007)
