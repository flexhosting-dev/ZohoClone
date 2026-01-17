import api from './api';
import type { DashboardData, Activity, PaginatedResponse } from '@/types';

export const dashboardService = {
  async getDashboard(): Promise<DashboardData> {
    const response = await api.get<DashboardData>('/dashboard');
    return response.data;
  },

  async getProjectActivities(projectId: string): Promise<Activity[]> {
    const response = await api.get<PaginatedResponse<Activity>>(`/projects/${projectId}/activities`);
    return response.data['hydra:member'] || response.data as unknown as Activity[];
  },
};
