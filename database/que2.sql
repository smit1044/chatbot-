use chatbot;
-- Users Table
CREATE TABLE Users (
    UserID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    Address TEXT,
    Phone VARCHAR(20) UNIQUE NOT NULL
);

-- Products Table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(255) NOT NULL,
    Description TEXT,
    Price DECIMAL(10,2) NOT NULL,
    Stock INT NOT NULL
);

-- Orders Table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    OrderDate DATETIME DEFAULT NOW(),
    Status ENUM('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled'),
    TotalAmount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

-- Order Items Table (For multiple products in an order)
CREATE TABLE Order_Items (
    OrderItemID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    ProductID INT,
    Quantity INT NOT NULL,
    Subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON DELETE CASCADE
);

-- Returns Table
CREATE TABLE Returns (
    ReturnID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    Reason TEXT NOT NULL,
    ReturnStatus ENUM('Pending', 'Approved', 'Rejected'),
    RequestDate DATETIME DEFAULT NOW(),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE
);

-- Tracking Table
CREATE TABLE Tracking (
    TrackingID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    Status ENUM('Processing', 'Shipped', 'Out for Delivery', 'Delivered', 'Cancelled'),
    UpdatedAt DATETIME DEFAULT NOW(),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE
);

show tables;

INSERT INTO Users (Name, Email, Address, Phone) VALUES
('John Doe', 'john@example.com', '123 Main St, NY', '9876543210'),
('Alice Smith', 'alice@example.com', '456 Oak St, CA', '8765432109'),
('Bob Johnson', 'bob@example.com', '789 Pine St, TX', '7654321098'),
('Emily Davis', 'emily@example.com', '321 Birch St, FL', '6543210987'),
('Michael Brown', 'michael@example.com', '654 Cedar St, WA', '5432109876'),
('Sophia Wilson', 'sophia@example.com', '987 Maple St, IL', '4321098765'),
('David Lee', 'david@example.com', '159 Spruce St, CO', '3210987654'),
('Jessica White', 'jessica@example.com', '753 Elm St, OH', '2109876543'),
('Daniel Martinez', 'daniel@example.com', '852 Pineapple St, NV', '1098765432'),
('Sophia Anderson', 'sophia.a@example.com', '369 Orange St, MA', '9988776655');

INSERT INTO Products (Name, Description, Price, Stock) VALUES
('Wireless Mouse', 'Ergonomic wireless mouse', 25.99, 100),
('Gaming Keyboard', 'RGB mechanical keyboard', 79.99, 50),
('USB-C Charger', 'Fast-charging adapter', 15.50, 200),
('Bluetooth Headphones', 'Noise-canceling headphones', 59.99, 75),
('Smartwatch', 'Fitness tracking smartwatch', 199.99, 30),
('Laptop Cooling Pad', 'Keeps your laptop cool', 34.99, 80),
('Mechanical Keyboard', 'Mechanical switches for better typing', 99.99, 40),
('External Hard Drive 1TB', '1TB storage capacity', 89.99, 60),
('Wireless Earbuds', 'True wireless sound', 49.99, 120),
('Portable Speaker', 'Loud and clear sound', 39.99, 90);

INSERT INTO Orders (UserID, OrderDate, Status, TotalAmount) VALUES
(1, NOW(), 'Pending', 149.99),
(2, NOW(), 'Shipped', 79.99),
(3, NOW(), 'Delivered', 999.99),
(4, NOW(), 'Cancelled', 49.99),
(5, NOW(), 'Processing', 199.50),
(6, NOW(), 'Shipped', 129.99),
(7, NOW(), 'Pending', 89.90),
(8, NOW(), 'Delivered', 59.99),
(9, NOW(), 'Processing', 349.00),
(10, NOW(), 'Shipped', 149.75);

INSERT INTO Order_Items (OrderID, ProductID, Quantity, Subtotal) VALUES
(1, 1, 2, 51.98),
(1, 3, 1, 15.50),
(2, 2, 1, 79.99),
(3, 5, 1, 199.99),
(3, 6, 1, 34.99),
(4, 8, 1, 89.99),
(5, 9, 1, 49.99),
(6, 7, 1, 99.99),
(7, 10, 1, 39.99),
(8, 4, 2, 119.98);

INSERT INTO Returns (OrderID, Reason, ReturnStatus, RequestDate) VALUES
(1, 'Product not working', 'Pending', NOW()),
(3, 'Received wrong item', 'Approved', NOW()),
(5, 'Changed my mind', 'Pending', NOW()),
(7, 'Defective product', 'Rejected', NOW()),
(9, 'Item arrived late', 'Approved', NOW()),
(2, 'Better price found elsewhere', 'Pending', NOW()),
(4, 'Product quality not as expected', 'Rejected', NOW()),
(6, 'Ordered by mistake', 'Pending', NOW()),
(8, 'Received damaged item', 'Approved', NOW()),
(10, 'Size/color issue', 'Pending', NOW());

INSERT INTO Tracking (OrderID, Status, UpdatedAt) VALUES
(1, 'Processing', NOW()),
(2, 'Shipped', NOW()),
(3, 'Out for Delivery', NOW()),
(4, 'Cancelled', NOW()),
(5, 'Processing', NOW()),
(6, 'Shipped', NOW()),
(7, 'Processing', NOW()),
(8, 'Delivered', NOW()),
(9, 'Shipped', NOW()),
(10, 'Out for Delivery', NOW());

SELECT * FROM Users;
SELECT * FROM Products;
SELECT * FROM Orders;
SELECT * FROM Order_Items;
SELECT * FROM Returns;
SELECT * FROM Tracking;

CREATE TABLE chatbot_responses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_question VARCHAR(255) UNIQUE NOT NULL,
    bot_response TEXT NOT NULL
);


INSERT INTO chatbot_responses (user_question, bot_response) VALUES
("Where is my order?", "Please provide your order ID to track it."),
("How do I return an item?", "You can request a return through your account under 'Orders'."),
("Track my order #12345", "Your order is currently out for delivery.");

INSERT INTO chatbot_responses (user_question, bot_response) VALUES
("How long does shipping take?", "Standard shipping takes 3-5 business days."),
("Do you have a refund policy?", "Yes, we have a 30-day refund policy."),
("What payment methods do you accept?", "We accept credit cards, PayPal, and Amazon Pay.");


INSERT INTO chatbot_responses (user_question, bot_response) VALUES
("How do I change my delivery address?", "You can update your address in the 'My Orders' section before the order is shipped."),
("Can I change my order after payment?", "Once an order is placed, changes are limited. Please contact customer support for help."),
("What are your customer service hours?", "Our support team is available from 9 AM to 9 PM."),
("Do you have an exchange policy?", "Yes, we allow exchanges within 30 days for eligible items."),
("How do I track my return?", "You can track your return status in the 'Returns' section of your account."),
("What happens if my package is lost?", "If your package is lost, please contact support, and we will investigate."),
("Can I get a discount code?", "Discount codes are available during promotions. Check our homepage for offers!"),
("Do you support cash on delivery?", "Yes, cash on delivery is available for selected locations."),
("How do I contact customer support?", "You can reach out via email, live chat, or phone from our support page."),
("What if I receive a damaged product?", "If your product is damaged, initiate a return request and we'll replace it.");

INSERT INTO chatbot_responses (user_question, bot_response) VALUES
("What is the estimated delivery time?", "Delivery time depends on your location and shipping method. Standard delivery takes 3-5 business days."),
("How do I cancel my order?", "You can cancel your order from 'My Orders' before it is shipped."),
("Can I schedule a delivery?", "Currently, we do not support scheduled deliveries."),
("How do I apply a promo code?", "You can enter your promo code at checkout under the 'Discount' section."),
("What if I missed my delivery?", "If you missed your delivery, the courier will attempt another delivery or leave instructions."),
("How do I return a product if I don’t like it?", "If your item is eligible for return, you can request a return within 30 days."),
("How do I check my order history?", "Go to 'My Account' > 'Order History' to view all your past orders."),
("Do you offer gift wrapping?", "Yes! You can select the gift wrap option at checkout."),
("Can I buy now and pay later?", "We support 'Buy Now, Pay Later' with selected payment providers."),
("How do I change my phone number on my account?", "You can update your phone number in the 'Account Settings' section."),
("Do you provide international shipping?", "Yes, we ship internationally. Shipping costs may vary based on location."),
("What if I receive the wrong item?", "If you received the wrong item, please contact support for a free replacement."),
("How do I track my shipment?", "Go to 'My Orders' and click on 'Track Order' to see the latest updates."),
("Do you provide bulk discounts?", "Yes! For bulk purchases, please contact our sales team."),
("How do I update my payment method?", "You can update your saved payment methods in 'Account Settings'.");

INSERT INTO chatbot_responses (user_question, bot_response) VALUES
("nice", "Thank you. do you need anymore help?"),
("okay", "Yes sir/mam.do you need anymore help?");

INSERT INTO chatbot_responses (user_question, bot_response) VALUES
("no", "Okay. ask me if you need any help"),
("yes", "What can i help you with?");


SELECT * FROM orders WHERE userid = 1;