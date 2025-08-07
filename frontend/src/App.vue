<template>
  <div id="app">
    <header>
      <h1>FastAPI + Vue + SQLite Boilerplate</h1>
    </header>
    
    <main>
      <ItemManager />
    </main>
    
    <footer>
      <p>&copy; 2023 FastAPI + Vue Boilerplate</p>
    </footer>
  </div>
</template>

<script>
import ItemManager from './components/ItemManager.vue'

export default {
  name: 'App',
  components: {
    ItemManager
  }
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}

header {
  margin-bottom: 30px;
}

footer {
  margin-top: 30px;
  padding: 20px;
  background-color: #f8f9fa;
  border-radius: 4px;
}
</style>