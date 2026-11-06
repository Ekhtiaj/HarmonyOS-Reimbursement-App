import { FormInfo, ExpenseItem } from '../models/ReimbursementModel';
import { StorageService } from '../services/StorageService';
import { BasicInfoSection } from '../views/BasicInfoSection';
import { ExpenseListSection } from '../views/ExpenseListSection';
import { CalculatorPopup } from '../views/CalculatorPopup';
import { PreviewDialog } from '../views/PreviewDialog';
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct Index {
  // Shared form state accessible by all child components (@Consume)
  @Provide('formInfo') formInfo: FormInfo = new FormInfo();

  // Local state variables for dialogs and dynamic calculations
  @State private showCalculator: boolean = false;
  @State private activeExpenseId: string = '';
  @State private showPreview: boolean = false;
  @State private totalExpense: number = 0;

  aboutToAppear(): void {
    this.updateTotal();
  }

  // Recalculates total reimbursement amount safely
  private updateTotal(): void {
    try {
      this.totalExpense = this.formInfo?.expenseList?.reduce(
        (acc: number, item: ExpenseItem) => acc + (item?.getNumericAmount() ?? 0),
        0
      ) ?? 0;
    } catch (e) {
      this.totalExpense = 0;
    }
  }

  // Helper method for alert dialogs using modern UIContext
  private showPrompt(title: string, message: string): void {
    try {
      this.getUIContext().showAlertDialog({
        title: title,
        message: message,
        confirm: {
          value: 'OK',
          action: () => {}
        }
      });
    } catch (err) {
      console.error(`Dialog error: ${JSON.stringify(err)}`);
    }
  }

  // Mandatory form validation logic
  private validateForm(): boolean {
    try {
      const name = this.formInfo?.travelerName ?? '';
      const purpose = this.formInfo?.purpose ?? '';

      if (name.trim().length === 0) {
        this.showPrompt('Validation Warning', 'Traveler name is required.');
        return false;
      }
      if (purpose.trim().length === 0) {
        this.showPrompt('Validation Warning', 'Trip purpose is required.');
        return false;
      }
      if (!this.formInfo?.agreementAccepted) {
        this.showPrompt('Validation Warning', 'Please agree to company reimbursement terms.');
        return false;
      }
      if ((this.formInfo?.expenseList?.length ?? 0) === 0) {
        this.showPrompt('Validation Warning', 'At least one expense item is required.');
        return false;
      }
      return true;
    } catch (err) {
      console.error(`Validation error: ${JSON.stringify(err)}`);
      return false;
    }
  }

  build() {
    // RelativeContainer wraps the page to position popups and dialogs
    RelativeContainer() {
      // Main Scrollable Form: ONLY ListItem components are direct children
      List({ space: 12 }) {
        // Item 1: Title Header
        ListItem() {
          Text('Business Trip Reimbursement')
            .fontSize(22)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1F2937')
            .margin({ top: 12, bottom: 6 })
            .width('100%')
            .textAlign(TextAlign.Center)
        }

        // Item 2: Section 1 - Basic Information
        ListItem() {
          BasicInfoSection()
        }

        // Item 3: Section 2 - Expense List
        ListItem() {
          ExpenseListSection({
            onOpenCalculator: (itemId: string, currentAmount: string) => {
              this.activeExpenseId = itemId;
              this.showCalculator = true;
            }
          })
        }

        // Item 4: Section 3 - Summary & Terms Agreement
        ListItem() {
          Column({ space: 10 }) {
            Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
              Text('Total Amount:')
                .fontSize(16)
                .fontWeight(FontWeight.Bold)

              Button('Refresh Total')
                .fontSize(12)
                .height(28)
                .backgroundColor('#4A90E2')
                .onClick(() => this.updateTotal())
            }

            Text(`$${this.totalExpense.toFixed(2)}`)
              .fontSize(24)
              .fontWeight(FontWeight.Bolder)
              .fontColor('#FF4D4F')
              .width('100%')
              .textAlign(TextAlign.End)

            Flex({ alignItems: ItemAlign.Center }) {
              Checkbox({ name: 'agreement', group: 'terms' })
                .select(this.formInfo?.agreementAccepted ?? false)
                .selectedColor('#007DFF')
                .onChange((value: boolean) => {
                  this.formInfo.agreementAccepted = value ?? false;
                })

              Text('I certify that all expenses reported are valid and work-related.')
                .fontSize(12)
                .fontColor('#6B7280')
                .margin({ left: 6 })
            }
          }
          .padding(12)
          .backgroundColor('#FFFFFF')
          .borderRadius(10)
          .width('100%')
        }

        // Item 5: Section 4 - Action Buttons
        ListItem() {
          Flex({ justifyContent: FlexAlign.SpaceBetween }) {
            Button('Save Draft')
              .width('48%')
              .backgroundColor('#34C759')
              .onClick(() => {
                const ctx = this.getUIContext().getHostContext() as common.UIAbilityContext;
                StorageService.saveDraft(ctx, this.formInfo)
                  .then((isSaved: boolean) => {
                    const msg = isSaved ? 'Draft successfully saved!' : 'Failed to save draft.';
                    this.showPrompt('Notice', msg);
                  })
                  .catch((err: Error) => {
                    this.showPrompt('Notice', 'Failed to save draft.');
                  });
              })

            Button('Verify & Preview')
              .width('48%')
              .backgroundColor('#007DFF')
              .onClick(() => {
                this.updateTotal();
                if (this.validateForm()) {
                  this.showPreview = true;
                }
              })
          }
          .width('100%')
          .margin({ top: 10, bottom: 40 })
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 14, right: 14 })
      .id('main_form_list')
      .alignRules({
        top: { anchor: '__container__', align: VerticalAlign.Top },
        left: { anchor: '__container__', align: HorizontalAlign.Start },
        right: { anchor: '__container__', align: HorizontalAlign.End },
        bottom: { anchor: '__container__', align: VerticalAlign.Bottom }
      })

      // Calculator Popup anchored in RelativeContainer
      if (this.showCalculator) {
        Column() {
          CalculatorPopup({
            onConfirmResult: (res: string) => {
              try {
                const target = this.formInfo?.expenseList?.find((it: ExpenseItem) => it.id === this.activeExpenseId);
                if (target) {
                  target.amountText = res ?? '0';
                }
                this.updateTotal();
              } catch (e) {
                console.error(`Failed to assign calculator result: ${JSON.stringify(e)}`);
              } finally {
                this.showCalculator = false;
              }
            },
            onClose: () => {
              this.showCalculator = false;
            }
          })
        }
        .id('calc_popup')
        .alignRules({
          middle: { anchor: '__container__', align: HorizontalAlign.Center },
          center: { anchor: '__container__', align: VerticalAlign.Center }
        })
        .zIndex(100)
      }

      // Preview Dialog anchored in RelativeContainer
      if (this.showPreview) {
        Column() {
          PreviewDialog({
            previewForm: $formInfo,
            onSubmitConfirm: () => {
              try {
                this.getUIContext().showAlertDialog({
                  title: 'Success',
                  message: 'Reimbursement application submitted successfully!',
                  confirm: {
                    value: 'OK',
                    action: () => {
                      this.formInfo = new FormInfo();
                      this.updateTotal();
                      this.showPreview = false;
                    }
                  }
                });
              } catch (e) {
                this.showPrompt('Error', 'Submission failed due to a system error.');
              }
            },
            onCancel: () => {
              this.showPreview = false;
            }
          })
        }
        .id('preview_dialog')
        .alignRules({
          middle: { anchor: '__container__', align: HorizontalAlign.Center },
          center: { anchor: '__container__', align: VerticalAlign.Center }
        })
        .zIndex(150)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F3F4F6')
  }
}