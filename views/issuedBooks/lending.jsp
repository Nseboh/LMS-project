<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lended Books</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/lending.css">
</head>
<body>
    <div class="form-container">
        <h1>Lended Books</h1>
        <form>
            <!-- User Information -->
            <fieldset>
                <legend>User Information</legend>
                <div class="form-group">
                    <label for="lenderName">Lender Name</label>
                    <input type="text" id="lenderName" required>
                </div>
                <div class="form-group">
                    <label for="membershipId">Membership ID</label>
                    <input type="text" id="membershipId" required>
                </div>
                <div class="form-group">
                    <label for="contactNumber">Contact Number</label>
                    <input type="text" id="contactNumber" required>
                </div>
            </fieldset>

            <!-- Book Information -->
            <fieldset>
                <legend>Book Information</legend>
                <div class="form-group">
                    <label for="bookTitle">Book Title</label>
                    <select id="bookTitle" required>
                        <option>Select from list</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="isbn">ISBN/ISSN</label>
                    <input type="text" id="isbn" value="978-92-95055-02-5" required>
                </div>
                <div class="form-group">
                    <label for="author">Author(s)</label>
                    <select id="author" required>
                        <option>Select from list</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="genre">Genre/Category</label>
                    <select id="genre" required>
                        <option>Select from list</option>
                    </select>
                </div>
            </fieldset>

            <!-- Lending Details -->
            <fieldset>
                <legend>Lending Details</legend>
                <div class="form-group">
                    <label for="lendingDate">Lending Date</label>
                    <input type="date" id="lendingDate" required>
                </div>
                <div class="form-group">
                    <label for="dueDate">Due Date</label>
                    <input type="date" id="dueDate" required>
                </div>
                <div class="form-group">
                    <label for="copiesLent">Copies Lent</label>
                    <input type="number" id="copiesLent" required>
                </div>
                <div class="form-group">
                    <label for="lendingStatus">Lending Status</label>
                    <select id="lendingStatus" required>
                        <option>Select status</option>
                    </select>
                </div>
            </fieldset>

            <!-- Additional Options -->
            <fieldset>
                <legend>Additional Options</legend>
                <div class="form-group">
                    <label for="notifications">Notifications</label>
                    <input type="checkbox" id="notifications">
                </div>
                <div class="form-group">
                    <label for="finePolicy">Fine Policy</label>
                    <input type="text" id="finePolicy">
                </div>
            </fieldset>

            <!-- Buttons -->
            <div class="form-actions">
                <button type="button" class="cancel">Cancel</button>
                <button type="submit" class="submit">Lend a Book</button>
            </div>
        </form>
    </div>
</body>
</html>