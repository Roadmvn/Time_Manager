import axios from 'axios';
import store from '../../store';

const instance = axios.create({
	baseURL: 'http://localhost:4000/api'
});

instance.interceptors.request.use(
	(config) => {
		const token = store.getters['auth/token'];
		if (token) {
			config.headers['Authorization'] = `Bearer ${token}`;
		}
		const xsrfToken = document.cookie.split('; ').find(row => row.startsWith('xsrf-token='));
		if (xsrfToken) {
			config.headers['X-XSRF-TOKEN'] = xsrfToken.split('=')[1];
		}
		return config;
	},
	(error) => {
		return Promise.reject(error);
	}
);

export default instance;
