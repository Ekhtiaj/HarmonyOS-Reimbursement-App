import { FormInfo, ExpenseItem } from '../models/ReimbursementModel';
@Component
export struct PreviewDialog {
  @Link previewForm: FormInfo;
  public onSubmitConfirm: () => void = () => {};
  public onCancel: () => void = () => {};

  private calculateTotal(): number {
    try {
      return this.previewForm?.expenseList?.reduce(
        (sum: number, item: ExpenseItem) => sum + (item?.getNumericAmount() ?? 0),
        0
      ) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  build() {
    Column({ space: 10 }) {
      Text('Reimbursement Preview (Read-Only)')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .width('100%')
        .textAlign(TextAlign.Center)
        .margin({ bottom: 8 })

      List({ space: 6 }) {
        ListItem() {
          Text(`Traveler: ${this.previewForm?.travelerName ?? 'N/A'}`)
        }
        ListItem() {
          Text(`Department: ${this.previewForm?.department ?? 'N/A'}`)
        }
        ListItem() {
          Text(`Purpose: ${this.previewForm?.purpose ?? 'N/A'}`)
        }
        ListItem() {
          Text(`Period: ${this.previewForm?.startDate ?? ''} to ${this.previewForm?.endDate ?? ''}`)
        }
        ListItem() {
          Text(`Destination: ${this.previewForm?.travelCity ?? 'N/A'}`)
        }
        ListItem() {
          Divider().margin({ top: 4, bottom: 4 })
        }
        ListItem() {
          Text('Expense Items:')
            .fontWeight(FontWeight.Bold)
        }

        ForEach(this.previewForm?.expenseList ?? [], (item: ExpenseItem, idx: number) => {
          ListItem() {
            Flex({ justifyContent: FlexAlign.SpaceBetween }) {
              Text(`${idx + 1}. [${item?.category ?? ''}] ${item?.remarks ?? 'No remarks'}`)
                .fontSize(13)
                .width('70%')

              Text(`$${item?.getNumericAmount().toFixed(2) ?? '0.00'}`)
                .fontSize(13)
                .fontWeight(FontWeight.Medium)
            }
          }
        }, (item: ExpenseItem) => item?.id ?? '')
      }
      .width('100%')
      .height(200)

      Divider()

      Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
        Text('Total Reimbursement:')
          .fontSize(15)
          .fontWeight(FontWeight.Bold)

        Text(`$${this.calculateTotal().toFixed(2)}`)
          .fontSize(18)
          .fontWeight(FontWeight.Bolder)
          .fontColor('#FF4D4F')
      }
      .width('100%')

      // Actions typeset with Flex
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('Modify')
          .width('40%')
          .backgroundColor('#8E8E93')
          .onClick(() => this.onCancel())

        Button('Confirm & Submit')
          .width('50%')
          .backgroundColor('#007DFF')
          .onClick(() => this.onSubmitConfirm())
      }
      .width('100%')
      .margin({ top: 10 })
    }
    .width('90%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .shadow({ radius: 24, color: 'rgba(0,0,0,0.25)' })
  }
}