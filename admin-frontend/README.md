# Admin Frontend - Tracking Jadwal & Obat

Admin panel web untuk Nakes (Healthcare Workers) mengelola jadwal dan informasi obat pasien.

## Tech Stack

- **Vue 3** - Progressive JavaScript framework
- **Vite** - Next generation frontend tooling
- **Pinia** - State management for Vue 3
- **Tailwind CSS** - Utility-first CSS framework
- **Axios** - HTTP client

## Struktur Folder

```
admin-frontend/
├── src/
│   ├── components/        # Reusable Vue components
│   ├── views/            # Page components
│   ├── stores/           # Pinia stores (state management)
│   ├── services/         # API services & Axios client
│   ├── router/           # Vue Router configuration
│   ├── assets/           # CSS & static files
│   ├── App.vue           # Root component
│   └── main.js           # Entry point
├── public/               # Static files
├── index.html            # HTML entry point
├── package.json          # Dependencies
├── vite.config.js        # Vite configuration
├── tailwind.config.js    # Tailwind configuration
└── postcss.config.js     # PostCSS configuration
```

## Features

- ✅ Admin authentication (login)
- ✅ Dashboard dengan statistik (total pasien & jadwal)
- ✅ Kelola pasien (view & delete)
- ✅ Kelola jadwal (create, read, update, delete)
- ✅ Info obat (create, read, update, delete)
- ✅ Sidebar navigation
- ✅ Responsive design dengan Tailwind CSS

## Setup & Installation

### Prerequisites
- Node.js 16+ 
- npm atau yarn

### Installation

```bash
# Navigate to admin-frontend directory
cd admin-frontend

# Install dependencies
npm install

# Start development server
npm run dev
```

Development server akan berjalan di `http://localhost:5173`

### Build for Production

```bash
npm run build
```

Output akan berada di folder `dist/`

## API Configuration

Backend API dikonfigurasi di `src/services/api.js`:

```javascript
const apiClient = axios.create({
  baseURL: 'http://localhost:8080/api/v1',
  // ...
})
```

Jika backend berjalan di port berbeda, update `baseURL` sesuai kebutuhan.

## Default Login

**Demo Account:**
- Email: `admin@example.com`
- Password: `password123`

(Sesuaikan dengan credential yang ada di backend)

## API Endpoints Used

- `POST /auth/admin/login` - Login admin
- `GET /admin/dashboard` - Dashboard stats
- `GET /admin/pasien` - Get all pasien
- `DELETE /admin/pasien/:id` - Delete pasien
- `GET /admin/jadwal` - Get all jadwal
- `POST /admin/jadwal` - Create jadwal
- `PUT /admin/jadwal/:id` - Update jadwal
- `DELETE /admin/jadwal/:id` - Delete jadwal
- `GET /info-obat` - Get all obat
- `POST /info-obat` - Create obat
- `PUT /info-obat/:id` - Update obat
- `DELETE /info-obat/:id` - Delete obat

## Development Notes

- State management menggunakan Pinia stores di `src/stores/`
- API calls dilakukan via `src/services/api.js` dan `src/services/index.js`
- Authentication token disimpan di localStorage
- Router guards dilakukan di `src/router/index.js`
- Styling menggunakan Tailwind CSS dengan custom theming di `tailwind.config.js`

## Next Steps

1. ✅ Setup Vue project struktur
2. [ ] Test integration dengan backend
3. [ ] Add form validation
4. [ ] Add loading states & error handling
5. [ ] Add user profile page
6. [ ] Add reports/analytics page
7. [ ] Deploy ke production

## License

MIT
