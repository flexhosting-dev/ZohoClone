import { useQuery } from '@tanstack/react-query';
import { dashboardService } from '@/services/dashboard';

export function useDashboard() {
  return useQuery({
    queryKey: ['dashboard'],
    queryFn: dashboardService.getDashboard,
  });
}

export function useProjectActivities(projectId: string) {
  return useQuery({
    queryKey: ['projects', projectId, 'activities'],
    queryFn: () => dashboardService.getProjectActivities(projectId),
    enabled: !!projectId,
  });
}
