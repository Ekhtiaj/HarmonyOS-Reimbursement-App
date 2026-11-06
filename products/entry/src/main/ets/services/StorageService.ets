import { preferences } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';
import { FormInfo } from '../models/ReimbursementModel';

export class StorageService {
  private static readonly PREF_NAME: string = 'ReimbursementDraft';
  private static readonly KEY_DRAFT: string = 'form_draft_data';

  /**
   * Saves the draft FormInfo object to ArkTS Preferences storage.
   */
  public static async saveDraft(context: common.UIAbilityContext, form: FormInfo): Promise<boolean> {
    try {
      const pref = await preferences.getPreferences(context, StorageService.PREF_NAME);
      const jsonStr = JSON.stringify(form);
      await pref.put(StorageService.KEY_DRAFT, jsonStr);
      await pref.flush();
      return true;
    } catch (err) {
      console.error(`StorageService: Failed to save draft. Error: ${JSON.stringify(err)}`);
      return false;
    }
  }

  /**
   * Loads the saved draft FormInfo object from ArkTS Preferences storage.
   */
  public static async loadDraft(context: common.UIAbilityContext): Promise<FormInfo | null> {
    try {
      const pref = await preferences.getPreferences(context, StorageService.PREF_NAME);
      const jsonStr = await pref.get(StorageService.KEY_DRAFT, '') as string;
      if (!jsonStr) {
        return null;
      }
      return JSON.parse(jsonStr) as FormInfo;
    } catch (err) {
      console.error(`StorageService: Failed to load draft. Error: ${JSON.stringify(err)}`);
      return null;
    }
  }

  /**
   * Clears the stored draft data from ArkTS Preferences storage.
   */
  public static async clearDraft(context: common.UIAbilityContext): Promise<void> {
    try {
      const pref = await preferences.getPreferences(context, StorageService.PREF_NAME);
      await pref.delete(StorageService.KEY_DRAFT);
      await pref.flush();
    } catch (err) {
      console.error(`StorageService: Failed to clear draft. Error: ${JSON.stringify(err)}`);
    }
  }
}