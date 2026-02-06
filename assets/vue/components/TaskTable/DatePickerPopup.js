import { ref, computed, watch, onMounted, onUnmounted, nextTick } from 'vue';

export default {
    name: 'DatePickerPopup',

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
        value: {
            type: String,
            default: ''
        },
        label: {
            type: String,
            default: 'Due Date'
        }
    },

    emits: ['close', 'select'],

    setup(props, { emit }) {
        const popupRef = ref(null);
        const inputRef = ref(null);
        const dateValue = ref('');

        // Adjusted position state
        const adjustedPos = ref({ x: 0, y: 0, ready: false });

        // Popup style using adjusted position
        const popupStyle = computed(() => {
            return {
                position: 'fixed',
                left: `${adjustedPos.value.x}px`,
                top: `${adjustedPos.value.y}px`,
                zIndex: 9999,
                visibility: adjustedPos.value.ready ? 'visible' : 'hidden'
            };
        });

        // Calculate and adjust position to stay within viewport
        const adjustPosition = async () => {
            adjustedPos.value.ready = false;

            await nextTick();
            if (!popupRef.value) return;

            const rect = popupRef.value.getBoundingClientRect();
            const viewportWidth = window.innerWidth;
            const viewportHeight = window.innerHeight;
            const popupHeight = rect.height;
            const popupWidth = rect.width;

            let adjustedX = props.x;
            let adjustedY = props.y;

            // Check right edge
            if (props.x + popupWidth > viewportWidth - 10) {
                adjustedX = viewportWidth - popupWidth - 10;
            }

            // Check bottom edge
            if (props.y + popupHeight > viewportHeight - 10) {
                adjustedY = viewportHeight - popupHeight - 10;
            }

            // Check left edge
            if (adjustedX < 10) {
                adjustedX = 10;
            }

            // Check top edge
            if (adjustedY < 10) {
                adjustedY = 10;
            }

            adjustedPos.value = {
                x: adjustedX,
                y: adjustedY,
                ready: true
            };
        };

        // Watch for visibility changes
        watch(() => props.visible, async (newVisible) => {
            if (newVisible) {
                dateValue.value = props.value || '';
                adjustedPos.value = { x: props.x, y: props.y, ready: false };
                await nextTick();
                adjustPosition();
                // Focus the input after positioning
                await nextTick();
                if (inputRef.value) {
                    inputRef.value.focus();
                    // Show the date picker
                    inputRef.value.showPicker?.();
                }
            }
        });

        // Watch for position changes while visible
        watch([() => props.x, () => props.y], () => {
            if (props.visible) {
                adjustedPos.value = { x: props.x, y: props.y, ready: false };
                nextTick(() => adjustPosition());
            }
        });

        // Handle click outside
        const handleClickOutside = (event) => {
            if (popupRef.value && !popupRef.value.contains(event.target)) {
                emit('close');
            }
        };

        // Handle escape key
        const handleKeydown = (event) => {
            if (event.key === 'Escape') {
                emit('close');
            } else if (event.key === 'Enter') {
                handleSave();
            }
        };

        // Quick date helpers
        const getToday = () => {
            return new Date().toISOString().split('T')[0];
        };

        const getTomorrow = () => {
            const date = new Date();
            date.setDate(date.getDate() + 1);
            return date.toISOString().split('T')[0];
        };

        const getNextWeek = () => {
            const date = new Date();
            date.setDate(date.getDate() + 7);
            return date.toISOString().split('T')[0];
        };

        const getNextMonth = () => {
            const date = new Date();
            date.setMonth(date.getMonth() + 1);
            return date.toISOString().split('T')[0];
        };

        // Handle quick date selection
        const selectQuickDate = (date) => {
            dateValue.value = date;
            emit('select', date);
            emit('close');
        };

        // Handle save
        const handleSave = () => {
            emit('select', dateValue.value || null);
            emit('close');
        };

        // Handle clear
        const handleClear = () => {
            dateValue.value = '';
            emit('select', null);
            emit('close');
        };

        // Handle date input change
        const handleDateChange = (event) => {
            dateValue.value = event.target.value;
        };

        // Lifecycle
        onMounted(() => {
            if (props.visible) {
                dateValue.value = props.value || '';
                adjustedPos.value = { x: props.x, y: props.y, ready: false };
                nextTick(() => adjustPosition());
            }
            document.addEventListener('mousedown', handleClickOutside);
            document.addEventListener('keydown', handleKeydown);
        });

        onUnmounted(() => {
            document.removeEventListener('mousedown', handleClickOutside);
            document.removeEventListener('keydown', handleKeydown);
        });

        return {
            popupRef,
            inputRef,
            popupStyle,
            dateValue,
            getToday,
            getTomorrow,
            getNextWeek,
            getNextMonth,
            selectQuickDate,
            handleSave,
            handleClear,
            handleDateChange
        };
    },

    template: `
        <Teleport to="body">
            <div
                v-if="visible"
                ref="popupRef"
                :style="popupStyle"
                class="bg-white rounded-lg shadow-lg border border-gray-200 p-3 min-w-[220px] select-none">

                <!-- Header -->
                <div class="text-sm font-medium text-gray-700 mb-3">{{ label }}</div>

                <!-- Date input -->
                <input
                    ref="inputRef"
                    type="date"
                    :value="dateValue"
                    @input="handleDateChange"
                    class="w-full px-3 py-2 border border-gray-300 rounded-md text-sm focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-primary-500 mb-3"
                />

                <!-- Quick date buttons -->
                <div class="flex flex-wrap gap-1.5 mb-3">
                    <button
                        type="button"
                        @click="selectQuickDate(getToday())"
                        class="px-2 py-1 text-xs font-medium text-gray-600 bg-gray-100 hover:bg-gray-200 rounded transition-colors">
                        Today
                    </button>
                    <button
                        type="button"
                        @click="selectQuickDate(getTomorrow())"
                        class="px-2 py-1 text-xs font-medium text-gray-600 bg-gray-100 hover:bg-gray-200 rounded transition-colors">
                        Tomorrow
                    </button>
                    <button
                        type="button"
                        @click="selectQuickDate(getNextWeek())"
                        class="px-2 py-1 text-xs font-medium text-gray-600 bg-gray-100 hover:bg-gray-200 rounded transition-colors">
                        +1 Week
                    </button>
                    <button
                        type="button"
                        @click="selectQuickDate(getNextMonth())"
                        class="px-2 py-1 text-xs font-medium text-gray-600 bg-gray-100 hover:bg-gray-200 rounded transition-colors">
                        +1 Month
                    </button>
                </div>

                <!-- Action buttons -->
                <div class="flex justify-between items-center pt-2 border-t border-gray-100">
                    <button
                        type="button"
                        @click="handleClear"
                        class="px-2 py-1 text-xs font-medium text-red-600 hover:text-red-700 hover:bg-red-50 rounded transition-colors">
                        Clear
                    </button>
                    <div class="flex gap-2">
                        <button
                            type="button"
                            @click="$emit('close')"
                            class="px-3 py-1.5 text-xs font-medium text-gray-600 hover:bg-gray-100 rounded transition-colors">
                            Cancel
                        </button>
                        <button
                            type="button"
                            @click="handleSave"
                            class="px-3 py-1.5 text-xs font-medium text-white bg-primary-600 hover:bg-primary-700 rounded transition-colors">
                            Save
                        </button>
                    </div>
                </div>
            </div>
        </Teleport>
    `
};
