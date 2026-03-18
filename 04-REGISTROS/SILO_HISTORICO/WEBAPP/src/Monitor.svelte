<script>
  import { onMount } from 'svelte';
  import { loadConfig, saveConfig, getState } from './api.js';

  let config = loadConfig() || {
    user: "",
    repo: "",
    file: "state.json"
  };

  let state = null;
  let loading = false;
  let error = null;

  function save() {
    saveConfig(config);
    loadState();
  }

  async function loadState() {
    loading = true;
    error = null;
    state = null;

    try {
      state = await getState();
    } catch (e) {
      error = e.message;
    }

    loading = false;
  }

  onMount(() => {
    if (config.user && config.repo) {
      loadState();
    }
  });
</script>

<style>
  .container { padding: 20px; max-width: 900px; margin: auto; }
  .card { background: #161b22; padding: 20px; border-radius: 10px; margin-bottom: 20px; }
  .input { width: 100%; padding: 10px; margin-bottom: 10px; border-radius: 6px; border: none; }
  .button { background: #238636; padding: 10px 20px; border-radius: 6px; cursor: pointer; display: inline-block; }
  .button:hover { background: #2ea043; }
  .error { color: #ff6b6b; }
</style>

<div class="container">
  <div class="card">
    <h2>Configuración del Monitor</h2>

    <input class="input" placeholder="Usuario de GitHub" bind:value={config.user} />
    <input class="input" placeholder="Repositorio" bind:value={config.repo} />
    <input class="input" placeholder="Archivo (state.json)" bind:value={config.file} />

    <div class="button" on:click={save}>Guardar y cargar estado</div>
  </div>

  <div class="card">
    <h2>Estado del Sistema</h2>

    {#if loading}
      <p>Cargando...</p>
    {:else if error}
      <p class="error">{error}</p>
    {:else if state}
      <pre>{JSON.stringify(state, null, 2)}</pre>
    {/if}
  </div>
</div>
