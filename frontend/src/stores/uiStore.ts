import { create } from 'zustand';
import { persist } from 'zustand/middleware';

interface UIState {
  sidebarCollapsed: boolean;
  taskViewMode: 'list' | 'kanban';

  // Actions
  toggleSidebar: () => void;
  setSidebarCollapsed: (collapsed: boolean) => void;
  setTaskViewMode: (mode: 'list' | 'kanban') => void;
}

export const useUIStore = create<UIState>()(
  persist(
    (set) => ({
      sidebarCollapsed: false,
      taskViewMode: 'list',

      toggleSidebar: () => set((state) => ({ sidebarCollapsed: !state.sidebarCollapsed })),
      setSidebarCollapsed: (collapsed: boolean) => set({ sidebarCollapsed: collapsed }),
      setTaskViewMode: (mode: 'list' | 'kanban') => set({ taskViewMode: mode }),
    }),
    {
      name: 'ui-storage',
    }
  )
);
