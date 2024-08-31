# Reviza Study Materials API

This API allows users to upload, retrieve, and manage study materials. It supports basic CRUD operations and is designed to be used with both mobile and web front-end applications.

## Base URL

The base URL for the API is:

```curl
http://127.0.0.1:8000/api/studyMaterials/
```

## Endpoints

### 1. Get All Study Materials

**Endpoint:**

```curl
GET /api/studyMaterials/
```

**Response:**

- Returns a list of all study materials stored in the system.

**Status Code:**

- `200 OK`

**Response Example:**

```json
[
  {
    "id": "6f4a898a-86e7-4136-9c1a-353ccd8bcf02",
    "type": "NOTES",
    "course_name": "MAT 4119 - ENGINEERING MATHEMATICS III",
    "title": "Maths",
    "description": "just trying",
    "file": "http://127.0.0.1:8000/study_materials/Chapter_1_Notes.pdf",
    "size": "194.83 KB",
    "uploaded_at": "2024-08-25T05:40:14.618172Z",
    "fans": [],
    "haters": [],
    "reports": []
  }
]
```
### 2. Filtering by course and/or type

**Endpoint:**

```curl
GET /api/studyMaterials/?course={course_name}&type={type}
```

**Path Parameter:**

- `name`: The unique name of the course that a particular material belongs to.
- `type`: Category the study material belongs to.

**Response:**

- Returns the details of the specific study material.

**Status Code:**

- `200 OK`

**Response Example:**

```json
{
    "id": "6f4a898a-86e7-4136-9c1a-353ccd8bcf02",
    "type": "NOTES",
    "course_name": "MAT 4119 - ENGINEERING MATHEMATICS III",
    "title": "Maths",
    "description": "just trying",
    "file": "http://127.0.0.1:8000/study_materials/Chapter_1_Notes.pdf",
    "size": "194.83 KB",
    "uploaded_at": "2024-08-25T05:40:14.618172Z",
    "fans": [],
    "haters": [],
    "reports": []
}
```


### 2. Get a Single Study Material

**Endpoint:**

```curl
GET /api/studyMaterials/{id}/
```

**Path Parameter:**

- `id`: The unique identifier of the study material.

**Response:**

- Returns the details of the specific study material.

**Status Code:**

- `200 OK`

**Response Example:**

```json
{
    "id": "6f4a898a-86e7-4136-9c1a-353ccd8bcf02",
    "type": "NOTES",
    "course_name": "MAT 4119 - ENGINEERING MATHEMATICS III",
    "title": "Maths",
    "description": "just trying",
    "file": "http://127.0.0.1:8000/study_materials/Chapter_1_Notes.pdf",
    "size": "194.83 KB",
    "uploaded_at": "2024-08-25T05:40:14.618172Z",
    "fans": [],
    "haters": [],
    "reports": []
}
```

### 3. Create a New Study Material

**Endpoint:**

```curl
POST /api/studyMaterials/
```

**Request Body:**

- Use `multipart/form-data` to upload files.
- Required fields are `type`, `subject_name`, `title`, `description`, and `file`.

**Request Example:**

```json
{
  "type": "NOTE",
  "subject_name": "Math",
  "title": "Chess",
  "description": "Kaya",
  "file": "path/to/your/file.pdf"
}
```

**Response:**

- Returns the created study material.

**Status Code:**

- `201 Created`

### 4. Update a Study Material

**Endpoint:**

```curl
PUT /api/studyMaterials/{id}/
```

**Path Parameter:**

- `id`: The unique identifier of the study material.

**Request Body:**

- All fields are required. This endpoint will replace the existing data.

**Request Example:**

```json
{
  "type": "NOTE",
  "subject_name": "Math",
  "title": "Updated Title",
  "description": "Updated Description",
  "file": "path/to/your/updated_file.pdf"
}
```

**Response:**

- Returns the updated study material.

**Status Code:**

- `200 OK`

### 5. Partially Update a Study Material

**Endpoint:**

```curl
PATCH /api/studyMaterials/{id}/
```

**Path Parameter:**

- `id`: The unique identifier of the study material.

**Request Body:**

- Only the fields that need to be updated should be included in the request body.

**Request Example:**

```json
{
  "title": "Updated Title",
  "description": "Updated Description"
}
```

**Response:**

- Returns the updated study material.

**Status Code:**

- `200 OK`

### 6. Delete a Study Material

**Endpoint:**

```curl
DELETE /api/studyMaterials/{id}/
```

**Path Parameter:**

- `id`: The unique identifier of the study material.

**Response:**

- Returns a success message or an empty response.

**Status Code:**

- `204 No Content`

## Fields

- **id**: Unique identifier for the study material, automatically generated.
- **type**: The type of the study material (e.g., Note, Book, Video).
- **subject_name**: The subject to which the study material belongs.
- **title**: The title of the study material.
- **description**: A short description of the study material.
- **file**: URL to the uploaded file.
- **size**: The size of the uploaded file (automatically calculated and stored).
- **uploaded_at**: The date and time when the study material was uploaded.

## Usage Notes

- **File Upload:** The `file` field is used to upload files. The API automatically calculates the file size and stores it in the `size` field.
- **UUIDs:** The `id` field is automatically generated using UUIDs, ensuring each study material has a unique identifier.
- **Date Handling:** The `uploaded_at` field records when the study material is first created.

---

This API is designed to be flexible and easy to integrate with both web and mobile applications. If you have any questions or issues, please refer to the documentation or contact the backend development team. <kanyanta.1makasa@gmail.com>
