# IT Lab Equipment Tracker 🖥️

A digital checkout system designed to replace manual logbooks in university computer laboratories. This web application allows IT students to easily borrow and track lab equipment (like crimping tools, mice, and keyboards) while ensuring laboratory custodians have a clear, accurate overview of current inventory.

## 🎯 Features

* **Student Authentication:** Secure User Registration and Login system.
* **Account Management:** Users can update their passwords to maintain account security.
* **Student Dashboard:** Displays the active user's Student ID (Account Number), Name, and Date Registered.
* **Equipment Checkout (Create/Read):** Students can submit a "Borrow Request" by selecting available equipment from a dropdown list.
* **Inventory Tracking:** A real-time table displaying items the student currently holds versus items they have successfully returned.
* **Request Cancellation (Delete):** Students can cancel a pending borrow request before picking up the item from the custodian.

## 🛠️ Technology Stack

* **Front-End:** HTML5, CSS3, ASP.NET Web Forms
* **Back-End:** C#
* **Database:** Microsoft SQL Server
* **Architecture:** Code-Behind Pattern

## 🗄️ Database Structure

The system is built on a relational SQL database utilizing three core tables:
1. **Users Table:** Manages student credentials and basic demographic information.
2. **Equipment Table:** Tracks the inventory and availability status (Boolean) of lab items.
3. **BorrowRequests Table:** Links students to specific equipment using Foreign Keys, tracking timestamps and request statuses (Pending, Picked Up, Returned).

## 🚀 How to Run Locally

1. Clone the repository to your local machine:
   ```bash
   git clone [https://github.com/loreenzooo/ctu-lab-equipment-tracker.git](https://github.com/loreenzooo/ctu-lab-equipment-tracker.git)
