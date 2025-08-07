from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Optional
import sqlite3
import os

# Initialize FastAPI app
app = FastAPI(title="FastAPI + Vue + SQLite Boilerplate")

# Add CORS middleware to allow frontend connections
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, specify exact origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Database setup
DATABASE_URL = "app.db"

def init_db():
    """Initialize the SQLite database with required tables"""
    conn = sqlite3.connect(DATABASE_URL)
    cursor = conn.cursor()
    
    # Create items table
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS items (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            description TEXT,
            price REAL
        )
    ''')
    
    conn.commit()
    conn.close()

# Initialize database on startup
@app.on_event("startup")
async def startup_event():
    init_db()

# Pydantic models for request/response validation
class ItemBase(BaseModel):
    name: str
    description: Optional[str] = None
    price: Optional[float] = None

class ItemCreate(ItemBase):
    pass

class ItemUpdate(ItemBase):
    name: Optional[str] = None

class Item(ItemBase):
    id: int
    
    class Config:
        orm_mode = True

# Helper functions for database operations
def get_db_connection():
    conn = sqlite3.connect(DATABASE_URL)
    conn.row_factory = sqlite3.Row
    return conn

# API Routes
@app.get("/")
def read_root():
    return {"message": "Welcome to FastAPI + Vue + SQLite Boilerplate"}

@app.get("/items/", response_model=List[Item])
def read_items():
    conn = get_db_connection()
    items = conn.execute('SELECT * FROM items').fetchall()
    conn.close()
    return [dict(item) for item in items]

@app.get("/items/{item_id}", response_model=Item)
def read_item(item_id: int):
    conn = get_db_connection()
    item = conn.execute('SELECT * FROM items WHERE id = ?', (item_id,)).fetchone()
    conn.close()
    
    if item is None:
        raise HTTPException(status_code=404, detail="Item not found")
    return dict(item)

@app.post("/items/", response_model=Item)
def create_item(item: ItemCreate):
    conn = get_db_connection()
    cursor = conn.cursor()
    
    cursor.execute('''
        INSERT INTO items (name, description, price)
        VALUES (?, ?, ?)
    ''', (item.name, item.description, item.price))
    
    item_id = cursor.lastrowid
    conn.commit()
    conn.close()
    
    return {**item.dict(), "id": item_id}

@app.put("/items/{item_id}", response_model=Item)
def update_item(item_id: int, item: ItemUpdate):
    conn = get_db_connection()
    existing_item = conn.execute('SELECT * FROM items WHERE id = ?', (item_id,)).fetchone()
    
    if existing_item is None:
        conn.close()
        raise HTTPException(status_code=404, detail="Item not found")
    
    # Update only provided fields
    name = item.name if item.name is not None else existing_item['name']
    description = item.description if item.description is not None else existing_item['description']
    price = item.price if item.price is not None else existing_item['price']
    
    conn.execute('''
        UPDATE items
        SET name = ?, description = ?, price = ?
        WHERE id = ?
    ''', (name, description, price, item_id))
    
    conn.commit()
    conn.close()
    
    return {**existing_item, "name": name, "description": description, "price": price}

@app.delete("/items/{item_id}")
def delete_item(item_id: int):
    conn = get_db_connection()
    cursor = conn.cursor()
    
    cursor.execute('DELETE FROM items WHERE id = ?', (item_id,))
    deleted_rows = cursor.rowcount
    conn.commit()
    conn.close()
    
    if deleted_rows == 0:
        raise HTTPException(status_code=404, detail="Item not found")
    
    return {"message": "Item deleted successfully"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)