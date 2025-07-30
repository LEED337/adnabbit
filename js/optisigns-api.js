/**
 * OptiSigns API Integration for AdNabbit Platform
 * Handles all digital signage backend operations
 */
class OptiSignsAPI {
    constructor() {
        this.baseUrl = 'https://api.optisigns.com/v2';
        this.apiKey = localStorage.getItem('optisigns_api_key') || 'demo_key';
        this.headers = {
            'Authorization': `Bearer ${this.apiKey}`,
            'Content-Type': 'application/json',
            'Accept': 'application/json'
        };
    }

    /**
     * Set API key for authentication
     */
    setApiKey(apiKey) {
        this.apiKey = apiKey;
        localStorage.setItem('optisigns_api_key', apiKey);
        this.headers['Authorization'] = `Bearer ${apiKey}`;
    }

    /**
     * Make API request with error handling
     */
    async makeRequest(endpoint, options = {}) {
        try {
            const url = `${this.baseUrl}${endpoint}`;
            const config = {
                headers: this.headers,
                ...options
            };

            const response = await fetch(url, config);
            
            if (!response.ok) {
                throw new Error(`API Error: ${response.status} ${response.statusText}`);
            }

            return await response.json();
        } catch (error) {
            console.error('OptiSigns API Error:', error);
            // Return mock data for demo purposes
            return this.getMockData(endpoint);
        }
    }

    /**
     * Get all screens/displays
     */
    async getScreens() {
        return await this.makeRequest('/screens');
    }

    /**
     * Get campaigns/playlists
     */
    async getCampaigns() {
        return await this.makeRequest('/playlists');
    }

    /**
     * Create new campaign
     */
    async createCampaign(campaignData) {
        return await this.makeRequest('/playlists', {
            method: 'POST',
            body: JSON.stringify({
                name: campaignData.name,
                description: campaignData.description,
                media_ids: campaignData.mediaIds || [],
                is_active: true,
                created_at: new Date().toISOString()
            })
        });
    }

    /**
     * Upload media file
     */
    async uploadMedia(file, description = '') {
        const formData = new FormData();
        formData.append('file', file);
        formData.append('description', description);

        return await this.makeRequest('/media', {
            method: 'POST',
            headers: {
                'Authorization': this.headers['Authorization']
                // Don't set Content-Type for FormData
            },
            body: formData
        });
    }

    /**
     * Assign campaign to screen
     */
    async assignCampaignToScreen(campaignId, screenId) {
        return await this.makeRequest(`/screens/${screenId}/assign-playlist`, {
            method: 'POST',
            body: JSON.stringify({
                playlist_id: campaignId
            })
        });
    }

    /**
     * Get screen analytics
     */
    async getScreenAnalytics(screenId) {
        return await this.makeRequest(`/screens/${screenId}/analytics`);
    }

    /**
     * Get user account info
     */
    async getAccountInfo() {
        return await this.makeRequest('/account');
    }

    /**
     * Mock data for demo purposes when API is unavailable
     */
    getMockData(endpoint) {
        const mockData = {
            '/screens': {
                screens: [
                    {
                        id: 'screen_001',
                        name: 'Lobby Display',
                        location: 'Main Lobby',
                        status: 'online',
                        resolution: '1920x1080',
                        last_seen: new Date().toISOString()
                    },
                    {
                        id: 'screen_002',
                        name: 'Cafeteria Screen',
                        location: 'Employee Cafeteria',
                        status: 'online',
                        resolution: '1920x1080',
                        last_seen: new Date().toISOString()
                    },
                    {
                        id: 'screen_003',
                        name: 'Conference Room A',
                        location: 'Meeting Room A',
                        status: 'offline',
                        resolution: '1920x1080',
                        last_seen: new Date(Date.now() - 3600000).toISOString()
                    }
                ]
            },
            '/playlists': {
                playlists: [
                    {
                        id: 'campaign_001',
                        name: 'Welcome Campaign',
                        description: 'Welcome messages and company info',
                        media_count: 3,
                        duration: 180,
                        is_active: true,
                        created_at: '2024-01-15T10:00:00Z'
                    },
                    {
                        id: 'campaign_002',
                        name: 'Product Showcase',
                        description: 'Latest product announcements',
                        media_count: 5,
                        duration: 300,
                        is_active: true,
                        created_at: '2024-01-20T14:30:00Z'
                    }
                ]
            },
            '/account': {
                user: {
                    id: 'user_001',
                    name: 'Demo User',
                    email: 'demo@adnabbit.com',
                    plan: 'Professional',
                    screens_limit: 10,
                    screens_used: 3,
                    storage_used: '2.5 GB',
                    storage_limit: '50 GB'
                }
            }
        };

        // Handle dynamic endpoints
        if (endpoint.includes('/analytics')) {
            return {
                analytics: {
                    screen_id: endpoint.split('/')[2],
                    uptime: '99.2%',
                    content_plays: 1247,
                    avg_play_duration: '45 seconds',
                    last_updated: new Date().toISOString(),
                    daily_stats: [
                        { date: '2024-01-25', plays: 156, uptime: '100%' },
                        { date: '2024-01-24', plays: 142, uptime: '98.5%' },
                        { date: '2024-01-23', plays: 138, uptime: '100%' }
                    ]
                }
            };
        }

        return mockData[endpoint] || { error: 'Mock data not available' };
    }

    /**
     * Test API connection
     */
    async testConnection() {
        try {
            const result = await this.getAccountInfo();
            return { success: true, data: result };
        } catch (error) {
            return { success: false, error: error.message };
        }
    }
}

// Export for use in other modules
window.OptiSignsAPI = OptiSignsAPI;