import { FormInfo } from '../models/ReimbursementModel';

@Component
export struct BasicInfoSection {
  @Consume('formInfo') formInfo: FormInfo;
  private departments: string[] = ['Engineering', 'Marketing', 'Sales', 'Finance', 'HR'];

  build() {
    Column() {
      Text('1. Traveler & Trip Information')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 8 })
        .width('100%')

      List({ space: 8 }) {
        // Traveler Name
        ListItem() {
          Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
            Text('Traveler Name*')
              .width('35%')
              .fontSize(14)

            TextInput({ text: this.formInfo?.travelerName ?? '', placeholder: 'Enter name' })
              .width('65%')
              .height(40)
              .backgroundColor('#F1F3F5')
              .borderRadius(6)
              .onChange((val: string) => {
                try {
                  this.formInfo.travelerName = val?.trim() ?? '';
                } catch (e) {
                  console.error(`Error updating name: ${JSON.stringify(e)}`);
                }
              })
          }
          .width('100%')
        }

        // Department Picker
        ListItem() {
          Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
            Text('Department')
              .width('35%')
              .fontSize(14)

            Select(this.departments.map((dept: string): SelectOption => ({ value: dept })))
              .selected(this.departments.indexOf(this.formInfo?.department ?? 'Engineering'))
              .value(this.formInfo?.department ?? 'Engineering')
              .width('65%')
              .onSelect((_, text?: string) => {
                this.formInfo.department = text ?? 'Engineering';
              })
          }
          .width('100%')
        }

        // Trip Purpose (Required)
        ListItem() {
          Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
            Text('Trip Purpose*')
              .width('35%')
              .fontSize(14)

            TextInput({ text: this.formInfo?.purpose ?? '', placeholder: 'Required purpose' })
              .width('65%')
              .height(40)
              .backgroundColor('#F1F3F5')
              .borderRadius(6)
              .onChange((val: string) => {
                this.formInfo.purpose = val?.trim() ?? '';
              })
          }
          .width('100%')
        }

        // Travel City
        ListItem() {
          Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
            Text('Travel City')
              .width('35%')
              .fontSize(14)

            TextInput({ text: this.formInfo?.travelCity ?? '', placeholder: 'e.g. Shenzhen' })
              .width('65%')
              .height(40)
              .backgroundColor('#F1F3F5')
              .borderRadius(6)
              .onChange((val: string) => {
                this.formInfo.travelCity = val ?? '';
              })
          }
          .width('100%')
        }

        // Start Date Selection
        ListItem() {
          Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
            Text('Start Date')
              .width('35%')
              .fontSize(14)

            Button(this.formInfo?.startDate ?? 'Pick Date')
              .width('65%')
              .height(36)
              .backgroundColor('#E8F3FF')
              .fontColor('#0A59F7')
              .onClick(() => {
                DatePickerDialog.show({
                  start: new Date('2020-01-01'),
                  end: new Date('2030-12-31'),
                  selected: new Date(),
                  onAccept: (value: DatePickerResult) => {
                    const y = value.year ?? 2026;
                    const m = (value.month ?? 0) + 1;
                    const d = value.day ?? 1;
                    this.formInfo.startDate = `${y}-${m.toString().padStart(2, '0')}-${d.toString().padStart(2, '0')}`;
                  }
                });
              })
          }
          .width('100%')
        }

        // End Date Selection
        ListItem() {
          Flex({ alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
            Text('End Date')
              .width('35%')
              .fontSize(14)

            Button(this.formInfo?.endDate ?? 'Pick Date')
              .width('65%')
              .height(36)
              .backgroundColor('#E8F3FF')
              .fontColor('#0A59F7')
              .onClick(() => {
                DatePickerDialog.show({
                  start: new Date('2020-01-01'),
                  end: new Date('2030-12-31'),
                  selected: new Date(),
                  onAccept: (value: DatePickerResult) => {
                    const y = value.year ?? 2026;
                    const m = (value.month ?? 0) + 1;
                    const d = value.day ?? 1;
                    this.formInfo.endDate = `${y}-${m.toString().padStart(2, '0')}-${d.toString().padStart(2, '0')}`;
                  }
                });
              })
          }
          .width('100%')
        }
      }
      .width('100%')
      .divider({ strokeWidth: 0.5, color: '#E0E0E0' })
    }
    .padding(12)
    .backgroundColor('#FFFFFF')
    .borderRadius(10)
    .width('100%')
  }
}