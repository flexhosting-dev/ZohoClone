import { ref, computed, onMounted, onUnmounted, watch, nextTick } from 'vue';

export default {
    name: 'ColumnContextMenu',

    props: {
        visible: {
            type: Boolean,
            default: false
        },
        x: {
            type: Number,
            default: 0
        },
        y: {
            type: Number,
            default: 0
        },
        column: {
            type: Object,
            default: null
        },
        sortColumn: {
            type: String,
            default: ''
        },
        sortDirection: {
            type: String,
            default: 'asc'
        },
        groupBy: {
            type: String,
            default: 'none'
        },
        groupableColumns: {
            type: Array,
            default: () => ['status', 'priority', 'milestone', 'assignees', 'dueDate']
        }
    },

    emits: ['close', 'sort-asc', 'sort-desc', 'clear-sort', 'hide-column', 'group-by', 'clear-grouping', 'reset-column-width'],

    setup(props, { emit }) {
        const menuRef = ref(null);
        const menuStyle = ref({});

        const isCurrentSortColumn = computed(() => {
            return props.column?.key === props.sortColumn;
        });

        const isSortedAsc = computed(() => {
            return isCurrentSortColumn.value && props.sortDirection === 'asc';
        });

        const isSortedDesc = computed(() => {
            return isCurrentSortColumn.value && props.sortDirection === 'desc';
        });

        const canSort = computed(() => {
            return props.column?.sortable;
        });

        const canGroup = computed(() => {
            return props.groupableColumns.includes(props.column?.key);
        });

        const isGroupedByThis = computed(() => {
            // Map column keys to groupBy values
            const keyToGroupBy = {
                'assignees': 'assignee',
                'dueDate': 'dueDate',
                'status': 'status',
                'priority': 'priority',
                'milestone': 'milestone'
            };
            const groupByValue = keyToGroupBy[props.column?.key] || props.column?.key;
            return props.groupBy === groupByValue;
        });

        const canHide = computed(() => {
            // Can't hide the title column
            return props.column?.key !== 'title' && props.column?.key !== 'checkbox';
        });

        // Position the menu
        const positionMenu = () => {
            if (!menuRef.value) return;

            const menuRect = menuRef.value.getBoundingClientRect();
            const viewportWidth = window.innerWidth;
            const viewportHeight = window.innerHeight;

            let left = props.x;
            let top = props.y;

            // Adjust if menu goes off right edge
            if (left + menuRect.width > viewportWidth - 10) {
                left = viewportWidth - menuRect.width - 10;
            }

            // Adjust if menu goes off bottom edge
            if (top + menuRect.height > viewportHeight - 10) {
                top = viewportHeight - menuRect.height - 10;
            }

            // Ensure menu doesn't go off left or top
            left = Math.max(10, left);
            top = Math.max(10, top);

            menuStyle.value = {
                left: `${left}px`,
                top: `${top}px`
            };
        };

        // Handle click outside
        const handleClickOutside = (event) => {
            if (menuRef.value && !menuRef.value.contains(event.target)) {
                emit('close');
            }
        };

        // Handle escape key
        const handleKeydown = (event) => {
            if (event.key === 'Escape') {
                emit('close');
            }
        };

        // Watch for visibility changes to add/remove listeners
        watch(() => props.visible, (newVisible) => {
            if (newVisible) {
                document.addEventListener('click', handleClickOutside);
                document.addEventListener('keydown', handleKeydown);
            } else {
                document.removeEventListener('click', handleClickOutside);
                document.removeEventListener('keydown', handleKeydown);
            }
        });

        // Watch for position changes to reposition menu (handles switching columns)
        watch([() => props.x, () => props.y], async () => {
            if (props.visible) {
                await nextTick();
                positionMenu();
            }
        });

        onUnmounted(() => {
            document.removeEventListener('click', handleClickOutside);
            document.removeEventListener('keydown', handleKeydown);
        });

        // Also reposition on mount if already visible
        onMounted(() => {
            if (props.visible) {
                nextTick(() => positionMenu());
            }
        });

        const handleSortAsc = () => {
            emit('sort-asc', props.column.key);
            emit('close');
        };

        const handleSortDesc = () => {
            emit('sort-desc', props.column.key);
            emit('close');
        };

        const handleClearSort = () => {
            emit('clear-sort');
            emit('close');
        };

        const handleHideColumn = () => {
            emit('hide-column', props.column.key);
            emit('close');
        };

        const handleGroupBy = () => {
            // Map column keys to groupBy values
            const keyToGroupBy = {
                'assignees': 'assignee',
                'dueDate': 'dueDate',
                'status': 'status',
                'priority': 'priority',
                'milestone': 'milestone'
            };
            const groupByValue = keyToGroupBy[props.column.key] || props.column.key;
            emit('group-by', groupByValue);
            emit('close');
        };

        const handleClearGrouping = () => {
            emit('clear-grouping');
            emit('close');
        };

        const handleResetColumnWidth = () => {
            emit('reset-column-width', props.column.key);
            emit('close');
        };

        return {
            menuRef,
            menuStyle,
            canSort,
            canGroup,
            canHide,
            isSortedAsc,
            isSortedDesc,
            isCurrentSortColumn,
            isGroupedByThis,
            handleSortAsc,
            handleSortDesc,
            handleClearSort,
            handleHideColumn,
            handleGroupBy,
            handleClearGrouping,
            handleResetColumnWidth
        };
    },

    template: `
        <div
            v-if="visible && column"
            ref="menuRef"
            :style="menuStyle"
            class="fixed z-50 bg-white rounded-lg shadow-lg ring-1 ring-black ring-opacity-5 py-1 min-w-[160px]"
            role="menu"
            aria-orientation="vertical">

            <!-- Sort Options -->
            <template v-if="canSort">
                <button
                    type="button"
                    class="w-full px-4 py-2 text-sm text-left flex items-center gap-2 hover:bg-gray-100"
                    :class="{ 'text-primary-600 font-medium': isSortedAsc }"
                    @click="handleSortAsc">
                    <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 15l7-7 7 7"/>
                    </svg>
                    Sort Ascending
                    <svg v-if="isSortedAsc" class="w-4 h-4 ml-auto text-primary-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                    </svg>
                </button>
                <button
                    type="button"
                    class="w-full px-4 py-2 text-sm text-left flex items-center gap-2 hover:bg-gray-100"
                    :class="{ 'text-primary-600 font-medium': isSortedDesc }"
                    @click="handleSortDesc">
                    <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/>
                    </svg>
                    Sort Descending
                    <svg v-if="isSortedDesc" class="w-4 h-4 ml-auto text-primary-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                    </svg>
                </button>
                <button
                    v-if="isCurrentSortColumn"
                    type="button"
                    class="w-full px-4 py-2 text-sm text-left flex items-center gap-2 hover:bg-gray-100 text-gray-500"
                    @click="handleClearSort">
                    <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                    </svg>
                    Clear Sort
                </button>
            </template>

            <!-- Divider -->
            <div v-if="canSort && (canGroup || canHide)" class="my-1 border-t border-gray-100"></div>

            <!-- Group Option -->
            <template v-if="canGroup">
                <button
                    v-if="!isGroupedByThis"
                    type="button"
                    class="w-full px-4 py-2 text-sm text-left flex items-center gap-2 hover:bg-gray-100"
                    @click="handleGroupBy">
                    <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"/>
                    </svg>
                    Group by {{ column.label }}
                </button>
                <button
                    v-else
                    type="button"
                    class="w-full px-4 py-2 text-sm text-left flex items-center gap-2 hover:bg-gray-100 text-primary-600"
                    @click="handleClearGrouping">
                    <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                    </svg>
                    Clear Grouping
                </button>
            </template>

            <!-- Divider -->
            <div v-if="canHide && (canSort || canGroup)" class="my-1 border-t border-gray-100"></div>

            <!-- Hide Column -->
            <button
                v-if="canHide"
                type="button"
                class="w-full px-4 py-2 text-sm text-left flex items-center gap-2 hover:bg-gray-100"
                @click="handleHideColumn">
                <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21"/>
                </svg>
                Hide Column
            </button>

            <!-- Reset Column Width -->
            <button
                type="button"
                class="w-full px-4 py-2 text-sm text-left flex items-center gap-2 hover:bg-gray-100"
                @click="handleResetColumnWidth">
                <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"/>
                </svg>
                Reset Width
            </button>
        </div>
    `
};
