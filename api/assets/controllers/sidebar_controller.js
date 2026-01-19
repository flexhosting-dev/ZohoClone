import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
    static targets = ['sidebar', 'overlay'];

    connect() {
        // Close sidebar when clicking outside
        document.addEventListener('click', this.handleOutsideClick.bind(this));
    }

    disconnect() {
        document.removeEventListener('click', this.handleOutsideClick.bind(this));
    }

    toggle(event) {
        event.stopPropagation();
        this.sidebarTarget.classList.toggle('-translate-x-full');
        this.sidebarTarget.classList.toggle('translate-x-0');
        this.overlayTarget.classList.toggle('hidden');
    }

    close() {
        this.sidebarTarget.classList.add('-translate-x-full');
        this.sidebarTarget.classList.remove('translate-x-0');
        this.overlayTarget.classList.add('hidden');
    }

    handleOutsideClick(event) {
        if (!this.sidebarTarget.contains(event.target) &&
            !event.target.closest('[data-action*="sidebar#toggle"]')) {
            this.close();
        }
    }
}
