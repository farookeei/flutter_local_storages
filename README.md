# Production-Grade Local Storage in Flutter

> Benchmarks, Maintenance Realities, Schema Migration Traps, Hardware-Backed Encryption, and Algorithmic Complexity across Modern Flutter Local Databases.

This repository accompanies the Medium publication: **[Production-Grade Local Storage in Flutter: Drift, Isar, Hive CE, ObjectBox & The Security Vault](https://medium.com/@farookyj10)**.

---

##  Repository Branch Architecture

Each storage engine implementation lives in its own isolated feature branch implementing a unified polymorphic `StorageRepository` interface.

```text
github.com/farookeei/flutter_local_storages
├── main                      <-- Base app template (UI, Contract Tests, Mock Storage)
├── feat/shared-preferences   <-- SharedPreferences implementation
├── feat/hive-ce              <-- Hive CE setup with TypeAdapters
├── feat/isar                 <-- Isar Collections & Schema Setup
├── feat/drift-sqlcipher      <-- Encrypted SQLCipher + Drift setup (Recommended)
└── feat/objectbox            <-- ObjectBox C++ Native setup
```

---

##  Clean Architecture per Branch

```text
lib/
├── core/
│   ├── database/             <-- Database drivers & initialization logic
│   └── security/             <-- Secure key management & hardware storage
├── features/
│   └── storage_demo/
│       ├── data/             <-- Storage driver repository implementations
│       ├── domain/           <-- Entities (TodoItem) & StorageRepository interface
│       └── presentation/     <-- Real-time Benchmark & Metric UI screens
└── main.dart
```

---

##  Algorithmic Complexity (Big-O Time & Space Matrix)

| Storage Engine | Write Time Complexity | Read Time Complexity | Disk Space Overhead | RAM Footprint | Primary Bottleneck |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **SharedPreferences** | $O(N)$ (Full File Rewrite) | $O(1)$ (In-Memory Cache) | $O(N)$ (XML Text Bloat) | $O(N)$ (Entire File in RAM) | Read-Write Amplification & Main-Thread Blocking |
| **Hive CE** | $O(1)$ (Log Append) | $O(1)$ (In-Memory Keys) | $O(N)$ (Append Log + Compaction) | $O(N)$ (Heap Index Copy) | Compaction Overhead & High Memory Usage |
| **Isar** | $O(1)$ (mmap + B-Tree) | $O(\log N)$ (Indexed) | $O(N)$ (Binary mmap Pages) | $O(1)$ (Zero-Copy mmap) | C++ NDK / Upstream Binding Maintenance |
| **Drift (SQLite)** | $O(1)$ (WAL B-Tree) | $O(\log N)$ (B-Tree Index) | $O(N)$ (Minimal SQL Pages) | $O(1)$ (Paged Buffer Cache) | SQL Parsing & Code-Gen Build Times |
| **ObjectBox** | $O(1)$ (FlatBuffers C++) | $O(1)$ (Zero-Copy Pointers) | $O(N)$ (Native FlatBuffers) | $O(1)$ (Native C++ Heap) | Native Binary Footprint (~2-4MB APK increase) |

---

## 🧪 Polymorphic Contract Unit Tests

Every feature branch MUST pass the exact same contract test suite to ensure architectural compliance:

```bash
# Run contract tests
flutter test test/widget_test.dart
```
