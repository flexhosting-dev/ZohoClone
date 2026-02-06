import { ref, computed, watch, onMounted, onUnmounted, nextTick } from 'vue';

/**
 * Reusable confirmation dialog component
 *
 * Usage:
 *   <ConfirmDialog ref="confirmDialog" />
 *
 *   // In setup:
 *   const confirmDialog = ref(null);
 *   const confirmed = await confirmDialog.value.show({
 *       title: 'Delete Task',
 *       message: 'Are you sure you want to delete this task?',
 *       confirmText: 'Delete',
 *       cancelText: 'Cancel',
 *       type: 'danger' // 'danger', 'warning', 'info'
 *   });
 */
export default {
    name: 'ConfirmDialog',

    setup(props, { expose }) {
        const isVisible = ref(false);
        const options = ref({
            title: 'Confirm',
            message: 'Are you sure?',
            confirmText: 'Confirm',
            cancelText: 'Cancel',
            type: 'danger' // 'danger', 'warning', 'info'
        });

        let resolvePromise = null;
        const dialogRef = ref(null);
        const confirmButtonRef = ref(null);

        // Type-based styling
        const typeStyles = computed(() => {
            switch (options.value.type) {
                case 'danger':
                    return {
                        icon: 'text-red-600 bg-red-100',
                        button: 'bg-red-600 hover:bg-red-700 focus:ring-red-500'
                    };
                case 'warning':
                    return {
                        icon: 'text-yellow-600 bg-yellow-100',
                        button: 'bg-yellow-600 hover:bg-yellow-700 focus:ring-yellow-500'
                    };
                case 'info':
                default:
                    return {
                        icon: 'text-blue-600 bg-blue-100',
                        button: 'bg-blue-600 hover:bg-blue-700 focus:ring-blue-500'
                    };
            }
        });

        // Show the dialog and return a promise
        const show = (opts = {}) => {
            options.value = {
                title: opts.title || 'Confirm',
                message: opts.message || 'Are you sure?',
                confirmText: opts.confirmText || 'Confirm',
                cancelText: opts.cancelText || 'Cancel',
                type: opts.type || 'danger'
            };
            isVisible.value = true;

            nextTick(() => {
                if (confirmButtonRef.value) {
                    confirmButtonRef.value.focus();
                }
            });

            return new Promise((resolve) => {
                resolvePromise = resolve;
            });
        };

        // Confirm action
        const confirm = () => {
            isVisible.value = false;
            if (resolvePromise) {
                resolvePromise(true);
                resolvePromise = null;
            }
        };

        // Cancel action
        const cancel = () => {
            isVisible.value = false;
            if (resolvePromise) {
                resolvePromise(false);
                resolvePromise = null;
            }
        };

        // Handle keyboard events
        const handleKeydown = (event) => {
            if (!isVisible.value) return;

            if (event.key === 'Escape') {
                event.preventDefault();
                cancel();
            } else if (event.key === 'Enter') {
                event.preventDefault();
                confirm();
            }
        };

        // Handle backdrop click
        const handleBackdropClick = (event) => {
            if (event.target === event.currentTarget) {
                cancel();
            }
        };

        onMounted(() => {
            document.addEventListener('keydown', handleKeydown);
        });

        onUnmounted(() => {
            document.removeEventListener('keydown', handleKeydown);
        });

        // Expose the show method for parent components
        expose({ show });

        return {
            isVisible,
            options,
            typeStyles,
            dialogRef,
            confirmButtonRef,
            confirm,
            cancel,
            handleBackdropClick
        };
    },

    template: `
        <Teleport to="body">
            <Transition
                enter-active-class="transition ease-out duration-200"
                enter-from-class="opacity-0"
                enter-to-class="opacity-100"
                leave-active-class="transition ease-in duration-150"
                leave-from-class="opacity-100"
                leave-to-class="opacity-0">
                <div
                    v-if="isVisible"
                    class="fixed inset-0 z-[10000] overflow-y-auto"
                    aria-labelledby="modal-title"
                    role="dialog"
                    aria-modal="true">
                    <!-- Backdrop -->
                    <div
                        class="flex min-h-screen items-center justify-center p-4 text-center sm:p-0"
                        @click="handleBackdropClick">
                        <!-- Backdrop overlay -->
                        <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" aria-hidden="true"></div>

                        <!-- Dialog panel -->
                        <Transition
                            enter-active-class="transition ease-out duration-200"
                            enter-from-class="opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
                            enter-to-class="opacity-100 translate-y-0 sm:scale-100"
                            leave-active-class="transition ease-in duration-150"
                            leave-from-class="opacity-100 translate-y-0 sm:scale-100"
                            leave-to-class="opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95">
                            <div
                                v-if="isVisible"
                                ref="dialogRef"
                                class="relative transform overflow-hidden rounded-lg bg-white text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-lg">
                                <div class="bg-white px-4 pb-4 pt-5 sm:p-6 sm:pb-4">
                                    <div class="sm:flex sm:items-start">
                                        <!-- Icon -->
                                        <div :class="['mx-auto flex h-12 w-12 flex-shrink-0 items-center justify-center rounded-full sm:mx-0 sm:h-10 sm:w-10', typeStyles.icon]">
                                            <!-- Danger/Warning icon -->
                                            <svg v-if="options.type === 'danger' || options.type === 'warning'" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                                                <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126zM12 15.75h.007v.008H12v-.008z" />
                                            </svg>
                                            <!-- Info icon -->
                                            <svg v-else class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                                                <path stroke-linecap="round" stroke-linejoin="round" d="M11.25 11.25l.041-.02a.75.75 0 011.063.852l-.708 2.836a.75.75 0 001.063.853l.041-.021M21 12a9 9 0 11-18 0 9 9 0 0118 0zm-9-3.75h.008v.008H12V8.25z" />
                                            </svg>
                                        </div>
                                        <!-- Content -->
                                        <div class="mt-3 text-center sm:ml-4 sm:mt-0 sm:text-left">
                                            <h3 class="text-base font-semibold leading-6 text-gray-900" id="modal-title">
                                                {{ options.title }}
                                            </h3>
                                            <div class="mt-2">
                                                <p class="text-sm text-gray-500">
                                                    {{ options.message }}
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <!-- Actions -->
                                <div class="bg-gray-50 px-4 py-3 sm:flex sm:flex-row-reverse sm:px-6 gap-2">
                                    <button
                                        ref="confirmButtonRef"
                                        type="button"
                                        @click="confirm"
                                        :class="['inline-flex w-full justify-center rounded-md px-3 py-2 text-sm font-semibold text-white shadow-sm sm:ml-3 sm:w-auto focus:outline-none focus:ring-2 focus:ring-offset-2', typeStyles.button]">
                                        {{ options.confirmText }}
                                    </button>
                                    <button
                                        type="button"
                                        @click="cancel"
                                        class="mt-3 inline-flex w-full justify-center rounded-md bg-white px-3 py-2 text-sm font-semibold text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50 sm:mt-0 sm:w-auto focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-gray-500">
                                        {{ options.cancelText }}
                                    </button>
                                </div>
                            </div>
                        </Transition>
                    </div>
                </div>
            </Transition>
        </Teleport>
    `
};
