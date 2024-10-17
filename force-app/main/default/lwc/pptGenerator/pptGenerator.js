// pptGenerator.js
import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAccountData from '@salesforce/apex/PowerPointDataController.getAccountData';
// Import the static resource
import PptxGenJS from '@salesforce/resourceUrl/pptxgenjs';

export default class PptGenerator extends LightningElement {
    account;

    @wire(getAccountData)
    wiredAccount({ error, data }) {
        if (data) {
            this.account = data;
        } else if (error) {
            this.showToast('Error', 'Error loading account data', 'error');
        }
    }

    generatePPT() {
        if (!this.account) {
            this.showToast('Error', 'No account data available', 'error');
            return;
        }

        // Load PptxGenJS library dynamically
        Promise.resolve().then(() => {
            const ppt = new window.PptxGenJS(); // Create a new presentation
            const slide = ppt.addSlide(); // Add a new slide

            // Add a title to the slide with Account Name
            slide.addText(`Account: ${this.account.Name}`, { x: 1, y: 1, fontSize: 24, color: '363636' });

            // Add another text field with more details (example: Industry)
            slide.addText(`Industry: ${this.account.Industry}`, { x: 1, y: 2, fontSize: 18, color: '555555' });

            // Generate the PPTX file
            ppt.writeFile({ fileName: `${this.account.Name}_Presentation.pptx` });
        }).catch((error) => {
            this.showToast('Error', 'Failed to generate PPT', 'error');
        });
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({ title, message, variant });
        this.dispatchEvent(event);
    }
}
