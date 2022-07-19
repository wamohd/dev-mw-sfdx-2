/**
 * Created by wamohd on 12.07.2022.
 */

import { LightningElement,api } from 'lwc';

export default class AccountNameEditor extends LightningElement {
    @api recordId;

    handleSubmit(event) {
        console.log("On Submit!");

    }

    handleSuccess(event) {
    console.log('Success changed!');
}
}