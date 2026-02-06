import { computed, ref, onMounted, onUnmounted } from 'vue';

export default {
    name: 'TableHeader',

    props: {
        columns: {
            type: Array,
            required: true
        },
        sortColumn: {
            type: String,
            default: 'position'
        },
        sortDirection: {
            type: String,
            default: 'asc'
        },
        allSelected: {
            type: Boolean,
            default: false
        },
        someSelected: {
            type: Boolean,
            default: false
        },
        canEdit: {
            type: Boolean,
            default: false
        }
    },

    emits: ['sort', 'select-all', 'column-contextmenu', 'resize-column'],

    setup(props, { emit }) {
        const visibleColumns = computed(() => {
            return props.columns.filter(col => col.visible);
        });

        // Column resizing state
        const resizing = ref(null); // { columnKey, startX, startWidth }

        const handleSort = (column) => {
            if (!column.sortable) return;
            emit('sort', column.key);
        };

        const getSortIcon = (column) => {
            if (!column.sortable) return '';
            if (props.sortColumn !== column.key) return 'neutral';
            return props.sortDirection;
        };

        const handleSelectAll = (event) => {
            emit('select-all', event.target.checked);
        };

        const getColumnWidth = (column) => {
            if (column.width === 'flex') return '';
            return typeof column.width === 'number' ? `${column.width}px` : column.width;
        };

        const handleContextMenu = (event, column) => {
            // Don't show context menu for checkbox column
            if (column.key === 'checkbox') return;
            event.preventDefault();
            emit('column-contextmenu', column, event);
        };

        // Check if column is resizable (not checkbox)
        const isResizable = (column) => {
            return column.key !== 'checkbox';
        };

        // Get X coordinate from mouse or touch event
        const getClientX = (event) => {
            if (event.touches && event.touches.length > 0) {
                return event.touches[0].clientX;
            }
            if (event.changedTouches && event.changedTouches.length > 0) {
                return event.changedTouches[0].clientX;
            }
            return event.clientX;
        };

        // Start resizing a column (mouse)
        const startResize = (event, column) => {
            event.preventDefault();
            event.stopPropagation();

            // Get the current width of the column
            const th = event.target.closest('th');
            const currentWidth = th ? th.offsetWidth : (typeof column.width === 'number' ? column.width : 100);

            resizing.value = {
                columnKey: column.key,
                startX: getClientX(event),
                startWidth: currentWidth
            };

            document.body.style.cursor = 'col-resize';
            document.body.style.userSelect = 'none';
        };

        // Start resizing a column (touch)
        const startResizeTouch = (event, column) => {
            // Prevent context menu and scrolling
            event.preventDefault();
            event.stopPropagation();

            const th = event.target.closest('th');
            const currentWidth = th ? th.offsetWidth : (typeof column.width === 'number' ? column.width : 100);

            resizing.value = {
                columnKey: column.key,
                startX: getClientX(event),
                startWidth: currentWidth
            };
        };

        // Handle mouse move during resize
        const handleMouseMove = (event) => {
            if (!resizing.value) return;

            const diff = getClientX(event) - resizing.value.startX;
            const newWidth = Math.max(50, resizing.value.startWidth + diff); // Minimum 50px

            emit('resize-column', resizing.value.columnKey, newWidth);
        };

        // Handle touch move during resize
        const handleTouchMove = (event) => {
            if (!resizing.value) return;

            // Prevent scrolling while resizing
            event.preventDefault();

            const diff = getClientX(event) - resizing.value.startX;
            const newWidth = Math.max(50, resizing.value.startWidth + diff);

            emit('resize-column', resizing.value.columnKey, newWidth);
        };

        // End resizing
        const handleMouseUp = () => {
            if (resizing.value) {
                resizing.value = null;
                document.body.style.cursor = '';
                document.body.style.userSelect = '';
            }
        };

        onMounted(() => {
            document.addEventListener('mousemove', handleMouseMove);
            document.addEventListener('mouseup', handleMouseUp);
            document.addEventListener('touchmove', handleTouchMove, { passive: false });
            document.addEventListener('touchend', handleMouseUp);
            document.addEventListener('touchcancel', handleMouseUp);
        });

        onUnmounted(() => {
            document.removeEventListener('mousemove', handleMouseMove);
            document.removeEventListener('mouseup', handleMouseUp);
            document.removeEventListener('touchmove', handleTouchMove);
            document.removeEventListener('touchend', handleMouseUp);
            document.removeEventListener('touchcancel', handleMouseUp);
        });

        return {
            visibleColumns,
            handleSort,
            getSortIcon,
            handleSelectAll,
            getColumnWidth,
            handleContextMenu,
            isResizable,
            startResize,
            startResizeTouch,
            resizing
        };
    },

    template: `
        <thead class="bg-gray-50 sticky top-0 z-10">
            <tr role="row">
                <th v-for="column in visibleColumns"
                    :key="column.key"
                    scope="col"
                    :style="{ width: getColumnWidth(column), minWidth: getColumnWidth(column) }"
                    :class="[
                        'px-3 py-3 text-left text-xs font-medium uppercase tracking-wide text-gray-500 relative',
                        column.sortable ? 'cursor-pointer hover:bg-gray-100 select-none' : '',
                        column.key === 'checkbox' ? 'w-10' : '',
                        column.width === 'flex' ? 'flex-1' : ''
                    ]"
                    :aria-sort="column.sortable ? (sortColumn === column.key ? (sortDirection === 'asc' ? 'ascending' : sortDirection === 'desc' ? 'descending' : 'none') : 'none') : undefined"
                    :tabindex="column.sortable ? 0 : undefined"
                    @click="handleSort(column)"
                    @contextmenu="handleContextMenu($event, column)"
                    @keydown.enter="handleSort(column)"
                    @keydown.space.prevent="handleSort(column)">

                    <!-- Checkbox column -->
                    <template v-if="column.key === 'checkbox' && canEdit">
                        <input
                            type="checkbox"
                            :checked="allSelected"
                            :indeterminate="someSelected && !allSelected"
                            @click.stop
                            @change="handleSelectAll"
                            class="h-4 w-4 rounded border-gray-300 text-primary-600 focus:ring-primary-500"
                            aria-label="Select all tasks"
                        />
                    </template>

                    <!-- Regular column header -->
                    <template v-else-if="column.key !== 'checkbox'">
                        <div class="flex items-center gap-1">
                            <!-- Spacer to align with task row expand button -->
                            <span v-if="column.key === 'title'" class="w-4 mr-1 flex-shrink-0"></span>
                            <span>{{ column.label }}</span>
                            <template v-if="column.sortable">
                                <!-- Neutral sort icon -->
                                <svg v-if="getSortIcon(column) === 'neutral'"
                                     class="w-4 h-4 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16V4m0 0L3 8m4-4l4 4m6 0v12m0 0l4-4m-4 4l-4-4"/>
                                </svg>
                                <!-- Ascending -->
                                <svg v-else-if="getSortIcon(column) === 'asc'"
                                     class="w-4 h-4 text-primary-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 15l7-7 7 7"/>
                                </svg>
                                <!-- Descending -->
                                <svg v-else-if="getSortIcon(column) === 'desc'"
                                     class="w-4 h-4 text-primary-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/>
                                </svg>
                            </template>
                        </div>
                    </template>

                    <!-- Column resize handle -->
                    <div
                        v-if="isResizable(column)"
                        class="absolute top-0 right-0 w-3 h-full cursor-col-resize flex items-center justify-center touch-none group/resize"
                        :class="{ 'bg-primary-100': resizing?.columnKey === column.key }"
                        @mousedown="startResize($event, column)"
                        @touchstart.prevent="startResizeTouch($event, column)"
                        @contextmenu.prevent
                        @click.stop
                    >
                        <!-- Visual grip indicator -->
                        <div class="w-px h-3 bg-gray-200 group-hover/resize:bg-gray-400 group-hover/resize:h-4 transition-all"
                             :class="{ '!bg-primary-400 !h-4': resizing?.columnKey === column.key }"></div>
                        <!-- Larger hit area for touch -->
                        <div class="absolute top-0 right-0 w-6 h-full -translate-x-1/2"></div>
                    </div>
                </th>
            </tr>
        </thead>
    `
};
