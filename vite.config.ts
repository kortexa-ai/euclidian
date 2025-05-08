import path from "path"
import react from "@vitejs/plugin-react-swc"
import tailwindcss from '@tailwindcss/vite'

import { defineConfig } from "vite";

import dotenv from 'dotenv';

const nodeEnv = process.env.NODE_ENV ?? 'development';
const envFiles = [
  `.env.${nodeEnv}.local`,
  `.env.${nodeEnv}`,
  '.env.local',
  '.env'
];

for (const file of envFiles) {
  dotenv.config({ path: file, override: true });
}

// @ts-expect-error process is a nodejs global
const host = process.env.TAURI_DEV_HOST;

export default defineConfig(async () => ({
  plugins: [
    react(),
    tailwindcss(),
  ],
  optimizeDeps: {
    esbuildOptions: {
      tsconfig: './tsconfig.app.json'
    },
  },
  resolve: {
    dedupe: [
      'react',
      'react-dom',
    ],
    alias: {
      "@": path.resolve(__dirname, './src'),
      'react': path.resolve(__dirname, './node_modules/react'),
      'react-dom': path.resolve(__dirname, './node_modules/react-dom'),
    },
  },
  build: {
    outDir: './dist',
    chunkSizeWarningLimit: 2500,
    rollupOptions: {
      external: [],
      output: {
        manualChunks: {
          'react-vendor': ['react', 'react-dom', 'react/jsx-runtime'],
          'ui-libs': ['class-variance-authority', 'tailwind-merge', 'clsx', 'lucide-react'],
        }
      }
    }
  },

  // Vite options tailored for Tauri development and only applied in `tauri dev` or `tauri build`
  //
  // 1. prevent vite from obscuring rust errors
  clearScreen: false,
  // 2. tauri expects a fixed port, fail if that port is not available
  server: {
    port: 1420,
    strictPort: true,
    host: host || false,
    hmr: host
      ? {
          protocol: "ws",
          host,
          port: 1421,
        }
      : undefined,
    watch: {
      // 3. tell vite to ignore watching `src-tauri`
      ignored: ["**/src-tauri/**"],
    },
  },
}));
