
## StackShare - File Sharing Smart Contract - README

### Overview

This smart contract is designed for a decentralized file-sharing platform built on the Stacks blockchain using Clarity. It enables users to upload, update, and manage digital files securely with customizable access control, metadata, version history, and storage tracking.

---

### ⚙️ Features

- **Upload Files** with metadata (name, description, tags, content type, etc.)
- **Set File Visibility** as private or public
- **Grant File Access** to specific users, optionally with expiration and editing rights
- **Update File Content** (new hash, size, versioning, changelog)
- **Edit Metadata** (name, description, tags)
- **Track Version History** per file
- **Enforce User Storage Limits** (file count and byte size)
- **Secure Access Control** with permission checks
- **Storage Statistics** per user

---

### 📦 Contract Constants

| Constant                         | Description                                 |
|----------------------------------|---------------------------------------------|
| `maximum-allowed-file-size`     | 1GB per file (1,073,741,824 bytes)          |
| `maximum-files-per-user-limit`  | Max 100 files per user                      |
| `minimum-file-name-length`      | File name must be at least 1 character      |
| `minimum-description-length`    | Description must be at least 1 character    |

---

### 🗂️ Data Structures

#### `file-registry`
Stores metadata and state of each file.

#### `file-access-control`
Manages per-user access and editing permissions.

#### `user-storage-metrics`
Tracks number of files and storage consumed by each user.

#### `file-version-tracking`
Stores the history of each file update.

#### `file-tag-index`
Stores file tags for categorization or filtering.

---

### 🔒 Access Control

- Only the file owner or users with explicit access can read file data.
- Editing a file requires explicit edit rights or ownership.
- Platform owner (contract deployer) is excluded from acting as a normal user.

---

### 🚀 Public Functions

#### ✅ Upload a New File
```clarity
(upload-new-file name hash size type description private? encrypted? tags)
```

#### ✏️ Update Existing File Content
```clarity
(update-existing-file file-id new-hash new-size changelog)
```

#### 🔐 Grant File Access With Expiry
```clarity
(grant-file-access-with-expiry file-id user-principal allow-edit? optional-expiry)
```

#### 🛠️ Update Metadata
```clarity
(update-file-metadata file-id optional-name optional-description optional-tags)
```

#### 🧾 Read File Version History
```clarity
(get-file-version-history file-id)
```

#### 👁️ Read File Details
```clarity
(get-file-details file-id)
```

#### 📊 Get User Storage Statistics
```clarity
(get-user-storage-statistics user-principal)
```

#### 🔎 Check Edit Permission
```clarity
(check-edit-permission file-id user-principal)
```

---

### 📌 Error Codes

| Error Code | Meaning                                |
|------------|----------------------------------------|
| `u100`     | Owner-only operation violation         |
| `u101`     | File not found                         |
| `u102`     | Unauthorized action                    |
| `u103`     | Invalid input                          |
| `u104`     | File already exists                    |
| `u105`     | Storage limit exceeded                 |

---

### ✅ Usage Notes

- All timestamps are based on `block-height`.
- All string fields have length limits to ensure efficient on-chain storage.
- Access expiration checks ensure permissions are time-bound.

---

### 🔒 Security Considerations

- The contract enforces access permissions strictly.
- All inputs undergo validation before state mutation.
- Owner-only functions (e.g., access grants) cannot be executed by unauthorized users.

---
