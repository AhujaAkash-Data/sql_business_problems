-- Problem: Display borrowers with a comma-separated list of books they have borrowed
-- Source: NamasteSQL
-- URL: https://www.namastesql.com/coding-problem/8-library-borrowing-habits?question_type=0&page=1
-- Difficulty: Easy
-- Concepts: Joins, GROUP_CONCAT, Aggregation, ORDER BY

-- Approach:
-- 1. Join the Borrowers table with the Books table using BookID.
-- 2. Group data by borrower name to aggregate borrowed books per borrower.
-- 3. Use GROUP_CONCAT to create a comma-separated list of book names.
-- 4. Order the book names alphabetically within each list.
-- 5. Sort the final output in ascending order of borrower name.

SELECT
    a.BorrowerName,
    GROUP_CONCAT(b.BookName ORDER BY b.BookName) AS borrowed_books
FROM Borrowers a
LEFT JOIN Books b
    ON a.BookID = b.BookID
GROUP BY a.BorrowerName
ORDER BY a.BorrowerName;
