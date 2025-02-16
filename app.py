from flask import Flask, render_template, request, redirect, url_for, jsonify
from flask_mysqldb import MySQL
import logging

app = Flask(__name__)

# MySQL configurations
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'user'
app.config['MYSQL_PASSWORD'] = 'root'
app.config['MYSQL_DB'] = 'moexbondsdb'
mysql = MySQL(app)

# Setup logging
logging.basicConfig(level=logging.DEBUG)

@app.route('/')
def index():
    return render_template('order-form.html')

@app.route('/submit_order', methods=['POST'])
def submit_order():
    try:
        data = request.json
        logging.debug(f"Received data: {data}")  # Логирование данных

        bond_name = data.get('bondName')
        order_type = data.get('orderType')
        lot_count = data.get('lotCount')
        execution_price = data.get('executionPrice')
        activation_price = data.get('activationPrice')
        execution_type = data.get('executionType')
        expiry_date = data.get('expiryDate')
        price_offset = data.get('priceOffset')
        price_offset_type = data.get('priceOffsetType')
        protection_spread = data.get('protectionSpread')
        protection_spread_type = data.get('protectionSpreadType')
        trailing_stop_activation = data.get('trailingStopActivation')
        created_at = data.get('createdAt')

        # Проверка обязательных полей
        if not bond_name or not order_type or not lot_count:
            return jsonify({'status': 'error', 'message': 'Missing required fields'}), 400

        cur = mysql.connection.cursor()

        # SQL-запрос с корректным количеством плейсхолдеров
        cur.execute("""
            INSERT INTO orders (
                user_id, broker_id, asset_name, order_type, quantity, price, activation_price, 
                execution_type, expiration_type, expiration_date, offset_value, offset_type, 
                activation_type, spread_value, spread_type, created_at, status
            ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, 'pending')
        """, (
            1, 1, bond_name, order_type, lot_count, execution_price, activation_price,
            execution_type, 'unlimited' if expiry_date is None else 'specific', expiry_date,
            price_offset, price_offset_type, trailing_stop_activation, protection_spread,
            protection_spread_type, created_at
        ))

        mysql.connection.commit()
        cur.close()

        return jsonify({'status': 'success'}), 200
    except Exception as e:
        logging.error(f"Error processing order: {e}", exc_info=True)
        return jsonify({'status': 'error', 'message': str(e)}), 500



if __name__ == '__main__':
    app.run(debug=True)