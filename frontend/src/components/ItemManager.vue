<template>
  <div class="item-manager">
    <!-- Messages -->
    <div v-if="errorMessage" class="error-message">
      {{ errorMessage }}
    </div>
    <div v-if="successMessage" class="success-message">
      {{ successMessage }}
    </div>
    
    <!-- Item Form -->
    <div class="form-container">
      <h2>{{ currentItem.id ? 'Edit Item' : 'Add New Item' }}</h2>
      <form @submit.prevent="saveItem">
        <div class="form-group">
          <label for="name">Name:</label>
          <input 
            type="text" 
            id="name" 
            v-model="currentItem.name" 
            required
          >
        </div>
        
        <div class="form-group">
          <label for="description">Description:</label>
          <textarea 
            id="description" 
            v-model="currentItem.description"
          ></textarea>
        </div>
        
        <div class="form-group">
          <label for="price">Price:</label>
          <input 
            type="number" 
            id="price" 
            v-model.number="currentItem.price" 
            step="0.01"
          >
        </div>
        
        <div class="form-actions">
          <button type="submit">{{ currentItem.id ? 'Update' : 'Create' }} Item</button>
          <button type="button" @click="resetForm" v-if="currentItem.id">Cancel</button>
        </div>
      </form>
    </div>
    
    <!-- Items List -->
    <div class="items-list">
      <h2>Items</h2>
      <div v-if="loading" class="loading">
        Loading items...
      </div>
      <div v-else>
        <table v-if="items.length > 0">
          <thead>
            <tr>
              <th>ID</th>
              <th>Name</th>
              <th>Description</th>
              <th>Price</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="item in items" :key="item.id">
              <td>{{ item.id }}</td>
              <td>{{ item.name }}</td>
              <td>{{ item.description }}</td>
              <td>${{ item.price }}</td>
              <td>
                <button @click="editItem(item)" class="edit-btn">Edit</button>
                <button @click="deleteItem(item.id)" class="delete-btn">Delete</button>
              </td>
            </tr>
          </tbody>
        </table>
        <div v-else class="no-items">
          No items found. Add your first item!
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'ItemManager',
  data() {
    return {
      items: [],
      currentItem: {
        id: null,
        name: '',
        description: '',
        price: null
      },
      errorMessage: '',
      successMessage: '',
      loading: false
    }
  },
  mounted() {
    this.fetchItems()
  },
  methods: {
    async fetchItems() {
      this.loading = true
      try {
        const response = await axios.get('/api/items/')
        this.items = response.data
        this.clearMessages()
      } catch (error) {
        this.errorMessage = 'Failed to fetch items: ' + (error.response?.data?.detail || error.message)
      } finally {
        this.loading = false
      }
    },
    
    async saveItem() {
      try {
        if (this.currentItem.id) {
          // Update existing item
          const response = await axios.put(`/api/items/${this.currentItem.id}`, this.currentItem)
          this.successMessage = 'Item updated successfully!'
          // Update item in the list
          const index = this.items.findIndex(item => item.id === this.currentItem.id)
          if (index !== -1) {
            this.items[index] = response.data
          }
        } else {
          // Create new item
          const response = await axios.post('/api/items/', this.currentItem)
          this.items.push(response.data)
          this.successMessage = 'Item created successfully!'
        }
        this.resetForm()
      } catch (error) {
        this.errorMessage = 'Failed to save item: ' + (error.response?.data?.detail || error.message)
      }
    },
    
    editItem(item) {
      this.currentItem = { ...item }
      this.clearMessages()
    },
    
    async deleteItem(id) {
      if (confirm('Are you sure you want to delete this item?')) {
        try {
          await axios.delete(`/api/items/${id}`)
          this.items = this.items.filter(item => item.id !== id)
          this.successMessage = 'Item deleted successfully!'
        } catch (error) {
          this.errorMessage = 'Failed to delete item: ' + (error.response?.data?.detail || error.message)
        }
      }
    },
    
    resetForm() {
      this.currentItem = {
        id: null,
        name: '',
        description: '',
        price: null
      }
      this.clearMessages()
    },
    
    clearMessages() {
      this.errorMessage = ''
      this.successMessage = ''
    }
  }
}
</script>

<style scoped>
.item-manager {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

.form-container {
  background-color: #f8f9fa;
  border-radius: 8px;
  padding: 20px;
  margin-bottom: 30px;
}

.form-container h2 {
  margin-top: 0;
}

.form-group {
  margin-bottom: 15px;
  text-align: left;
}

.form-group label {
  display: block;
  margin-bottom: 5px;
  font-weight: bold;
}

.form-group input,
.form-group textarea {
  width: 100%;
  padding: 8px;
  border: 1px solid #ddd;
  border-radius: 4px;
  box-sizing: border-box;
}

.form-actions {
  text-align: left;
}

.form-actions button {
  background-color: #007bff;
  color: white;
  padding: 10px 15px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  margin-right: 10px;
}

.form-actions button:hover {
  background-color: #0056b3;
}

.form-actions button[type="button"] {
  background-color: #6c757d;
}

.form-actions button[type="button"]:hover {
  background-color: #545b62;
}

.items-list {
  background-color: white;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}

.items-list h2 {
  margin-top: 0;
}

table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 15px;
}

th, td {
  padding: 12px;
  text-align: left;
  border-bottom: 1px solid #ddd;
}

th {
  background-color: #f8f9fa;
  font-weight: bold;
}

.edit-btn {
  background-color: #ffc107;
  color: #212529;
  border: none;
  padding: 5px 10px;
  border-radius: 4px;
  cursor: pointer;
  margin-right: 5px;
}

.edit-btn:hover {
  background-color: #e0a800;
}

.delete-btn {
  background-color: #dc3545;
  color: white;
  border: none;
  padding: 5px 10px;
  border-radius: 4px;
  cursor: pointer;
}

.delete-btn:hover {
  background-color: #c82333;
}

.error-message {
  background-color: #f8d7da;
  color: #721c24;
  padding: 10px;
  border-radius: 4px;
  margin-bottom: 15px;
}

.success-message {
  background-color: #d4edda;
  color: #155724;
  padding: 10px;
  border-radius: 4px;
  margin-bottom: 15px;
}

.loading {
  text-align: center;
  padding: 20px;
  font-style: italic;
  color: #6c757d;
}

.no-items {
  text-align: center;
  padding: 20px;
  color: #6c757d;
}
</style>