# Qus 1: Explain the Primary Key and Foreign Key concepts in PostgreSQL.

🟢 প্রাইমারি কী

প্রাইমারি কী একটি কলাম বা কলামসমূহের সমষ্টি যা একটি টেবিলের প্রতিটি রেকর্ডকে অন্য রেকর্ড থেকে আলাদা করে চিহ্নিত করে।

✅ বৈশিষ্ট্য:

- প্রতিটি রেকর্ডের জন্য একটি ইউনিক মান থাকে।
- এটি কখনই NULL হতে পারে না।
- একটি টেবিলে কেবলমাত্র একটি Primary Key থাকতে পারে।

🟢 ফরেন কী

ফরেন কী একটি কলাম যা অন্য একটি টেবিলের প্রাইমারি কী এর সাথে সম্পর্ক তৈরি করে। ফরেন কী এ ডুপ্লিকেট মান থাকতে পারে

✅ বৈশিষ্ট্য:

- এটি অন্য টেবিলের ডেটার সাথে সংযোগ (relation) তৈরি করে।
- ডুপ্লিকেট মান থাকতে পারে (একই কোর্সে একাধিক ছাত্র থাকতে পারে)।
- এটি NULL থাকতে পারে, যদি NOT NULL দিয়ে বাধ্যতামূলক না করা হয়।

ডাটাবেস ডিজাইন শিখতে গেলে আমরা খুব দ্রুত দুটো গুরুত্বপূর্ণ শব্দের মুখোমুখি হই – Primary Key এবং Foreign Key। এই দুটো জিনিস ঠিকমতো না বুঝলে ডাটাবেসে সম্পর্ক (relationship) তৈরি করা কঠিন হয়ে যায়।
সহজভাবে PostgreSQL ব্যবহার করে Primary Key ও Foreign Key এর ব্যাখ্যা — কোড ও উদাহরণ।

🎯 উদাহরণ:
ধরি আমাদের একটি courses নামের টেবিল আছে যেখানে সব কোর্সের তথ্য থাকবে:

```CREATE TABLE courses (
  course_id SERIAL PRIMARY KEY,
  course_name VARCHAR(100) NOT NULL
);
```

এখানে course_id হচ্ছে আমাদের Primary Key — প্রতিটি কোর্সের ইউনিক আইডি।

এবার students নামে একটি টেবিল তৈরি করি, যেখানে শিক্ষার্থীদের তথ্য থাকবে এবং তারা কোন কোর্সে ভর্তি সেটা উল্লেখ থাকবে।

```
CREATE TABLE students (
  student_id SERIAL PRIMARY KEY,
  student_name VARCHAR(100) NOT NULL,
  course_id INT,
  FOREIGN KEY (course_id) REFERENCES courses(course_id)
);
```

এখানে course_id হলো একটি Foreign Key, যা courses টেবিলের course_id কে রেফার করছে।

❌ ভুল Foreign Key দিলে কী হয়?

```
INSERT INTO students (student_name, course_id) VALUES
('David', 999);
```

এই ইনসার্টে Error আসবে, কারণ 999 নাম্বারের কোনো কোর্স courses টেবিলে নেই। PostgreSQL এর Foreign Key constraint এই ভুল ধরবে এবং ডেটা ইনসার্ট হতে দেবে না।

🔍 JOIN করে কোর্স সহ ছাত্রদের তথ্য দেখা

```
SELECT
  students.student_name,
  courses.course_name
FROM
  students
JOIN
  courses ON students.course_id = courses.course_id;
```

এই কোয়েরি চালালে আপনি প্রতিটি ছাত্র এবং তারা কোন কোর্সে ভর্তি তার তালিকা দেখতে পারবেন।

📌 সংক্ষেপে,

বিষয় | Primary Key | Foreign Key

ডুপ্লিকেট |❌ না | ✅ হ্যাঁ
NULL অনুমোদিত |❌ না |✅ হ্যাঁ (যদি NOT NULL না দেয়া হয়)

✍️ Primary Key ও Foreign Key ডাটাবেস ডিজাইনের মূল ভিত্তি। টেবিলগুলোর মধ্যে সুন্দর সম্পর্ক তৈরি হয় এবং ডেটার সম্পর্ক বজায় থাকে।

<hr>

# Qus 2: What is the difference between the VARCHAR and CHAR data types?

ডাটাবেস ডিজাইনের সময় প্রায়ই VARCHAR এবং CHAR এই দুইটি ডেটা টাইপ ব্যবহার হয়।

```
🔤 CHAR (Fixed Length)
```

CHAR(n) হলো ফিক্সড দৈর্ঘ্যের স্ট্রিং ডেটা টাইপ। এটি সর্বদা নির্দিষ্ট সংখ্যক ক্যারেক্টার রাখে — কম থাকলেও অতিরিক্ত অংশ স্পেস (space) দিয়ে পূরণ করে।

🔠 VARCHAR (Variable Length)
VARCHAR(n) হলো ভ্যারিয়েবল দৈর্ঘ্যের স্ট্রিং ডেটা টাইপ। এটি যতটুকু দরকার ততটুকুই জায়গা নেয়, অতিরিক্ত স্পেস ব্যবহার করে না।

🎯 উদাহরণ:

```
INSERT INTO users (code) VALUES ('AB');
```

➡️ এখানে code ফিল্ডে "AB" সংরক্ষিত হবে "AB " (3টি অতিরিক্ত স্পেস সহ)।

```
INSERT INTO users (username) VALUES ('Eftakhar');
```

➡️ এখানে "Eftakhar" নামটি ঠিক ৮টি ক্যারেক্টার হিসেবেই স্টোর হবে — কোনো অতিরিক্ত স্পেস নয়।

⚖️ পার্থক্য:

বিষয় | CHAR(n) | VARCHAR(n)
দৈর্ঘ্য | নির্দিষ্ট (Fixed) | পরিবর্তনশীল (Variable)
স্পেস ফিল করে? | ✅ হ্যাঁ |❌ না

📌 কখন কোনটি ব্যবহার হবে?

✅ CHAR ব্যবহার করুন যখন ডেটার দৈর্ঘ্য সবসময় সমান — যেমন: gender, country_code, status

✅ VARCHAR ব্যবহার করুন যখন ডেটার দৈর্ঘ্য ভিন্ন হতে পারে — যেমন: name, email, address

✍️ সংক্ষেপে বললে, CHAR হলো ফিক্সড দৈর্ঘ্যের, আর VARCHAR হলো পরিবর্তনশীল দৈর্ঘ্যের ডেটা টাইপ।

<hr>

# Qus 3: Explain the purpose of the WHERE clause in a SELECT statement.

ডাটাবেস থেকে ডেটা নেওয়ার সময় সবসময় আমাদের সব রেকর্ড দরকার হয় না। তখনই কাজে আসে WHERE ক্লজ — যা দিয়ে আমরা নির্দিষ্ট শর্ত অনুযায়ী ডেটা বের করে আনতে পারি।

❓ WHERE clause
WHERE ক্লজ ব্যবহার করা হয় ডেটা ফিল্টার করার জন্য — অর্থাৎ শুধুমাত্র সেই রেকর্ডগুলোকেই বের করে আনা হয় যেগুলো একটি নির্দিষ্ট শর্ত পূরণ করে।

📘 উদাহরণ:

```
SELECT column1, column2
FROM table_name
WHERE condition;
```

ধরি, আমাদের একটি students টেবিল আছে, যেখানে ছাত্রদের নাম এবং বয়স রাখা আছে।
✅ এখন যদি আমরা শুধুমাত্র ২০ বছরের বেশি বয়সের ছাত্রদের দেখতে চাই, তাহলে এইটা বাবহার করব

```
SELECT * FROM students
WHERE age > 20;
```

🛠️ WHERE ক্লজে কী কী অপারেটর ব্যবহার করা যায়?

```
= , != , <> ,

<, >, <=, >=

BETWEEN, LIKE, IN, IS NULL
```

WHERE ক্লজ হল একটি শক্তিশালী টুল যা দিয়ে আপনি ডাটাবেস থেকে শর্ত অনুযায়ী নির্দিষ্ট ডেটা বের করে আনতে পারবেন। এটি ডেটা বিশ্লেষণ, রিপোর্টিং এবং অ্যাপ্লিকেশন লজিকের জন্য অপরিহার্য।

<hr>

# Qus 4: What are the LIMIT and OFFSET clauses used for?

আপনি যখন বড় কোনো ডাটাবেস থেকে ডেটা আনেন, তখন সব রেকর্ড একসাথে দেখানো বাস্তবসম্মত না। এই অবস্থায় LIMIT ও OFFSET ক্লজ খুবই কাজের — বিশেষ করে Pagination এ ডেটা দেখানোর ক্ষেত্রে।

🎯 LIMIT clauses?

LIMIT ব্যবহার করে নির্দিষ্ট সংখ্যক রেকর্ড আনা হয়।

📘 উদাহরণ:

```
SELECT * FROM students
LIMIT 5;
```

➡️ এটি students টেবিল থেকে সর্বোচ্চ ৫টি রেকর্ড রিটার্ন করবে।

🎯 OFFSET clauses
OFFSET ব্যবহার করে নির্দিষ্ট সংখ্যক রেকর্ড স্কিপ করা হয়।

📘 উদাহরণ:

```
SELECT * FROM students
OFFSET 5;
```

➡️ এটি প্রথম ৫টি রেকর্ড বাদ দিয়ে পরের রেকর্ডগুলো দেখাবে।

🔁 LIMIT ও OFFSET একসাথে ব্যবহার

```
SELECT * FROM students
LIMIT 5 OFFSET 0;
```

📌 ক্লজ কাজ ?

LIMIT কতগুলো রেকর্ড আনতে চান সেটি নির্ধারণ করে
OFFSET কতগুলো রেকর্ড বাদ দিতে চান সেটি নির্ধারণ করে

LIMIT ও OFFSET একসাথে ব্যবহার করে সহজেই Pagination তৈরি করা যাই

<hr>

# Qus 5: Explain the GROUP BY clause and its role in aggregation operations.

GROUP BY clause SQL–এ ব্যবহার করা হয় যখন আমরা এক বা একাধিক কলামের ভিত্তিতে ডেটাকে গ্রুপ করে তার উপর বিভিন্ন aggregation করতে চাই, যেমন COUNT(), SUM(), AVG(), MAX(), MIN() ইত্যাদি। এই ক্লজটি মূলত বড় ডেটাসেটকে বিভাগভিত্তিক বিশ্লেষণ করতে সাহায্য করে।

🔍 GROUP BY
GROUP BY clause SQL–এ ব্যবহার করা হয় একই ধরনের রেকর্ডকে একত্র করে সংক্ষেপ তৈরি করতে। এটি সাধারণত COUNT(),
SUM(), AVG() ইত্যাদি ফাংশনের সঙ্গে ব্যবহার হয়।

🎯 সিনট্যাক্স:

```
SELECT column_name, AGGREGATE_FUNCTION(column_name)
FROM table_name
GROUP BY column_name;
```

📘 উদাহরণ:
আমরা জানতে চাই প্রতি ডিপার্টমেন্টে কতজন ছাত্র আছে।

```
SELECT department, COUNT(*) AS total_students
FROM students
GROUP BY department;
```

📌 GROUP BY + HAVING
GROUP BY–এর পরে আমরা চাইলে HAVING ব্যবহার করে গ্রুপ ফিল্টার করতে পারি (যেমন, যেসব ডিপার্টমেন্টে ২ জনের বেশি ছাত্র আছে)।

```
SELECT department, COUNT(*) AS total_students
FROM students
GROUP BY department
HAVING COUNT(*) > 1;
```

🧠 GROUP BY সবসময় SELECT-এ থাকা কলামগুলোর জন্য প্রয়োজন। এটি aggregation result তৈরি করতে সাহায্য করে।
